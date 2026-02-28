// ============================================================
// Route: จัดการสินค้า/ยา (Products API)
// หน้าที่: เป็นตัวกลาง (Middleware/Controller) รับ Request จากฝั่ง Web (Frontend) 
//         และส่งคำสั่งต่อไปยัง Oracle Database ตาราง Product
// เทคนิคกการเขียน: 
// - ป้องกัน SQL Injection ด้วยการใช้ Parameter Binding (:id)
// - โยนภาระงานซับซ้อนไปให้ Stored Procedure (sp_upsert_product, sp_delete_product) ทำแทน
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const oracledb = db.oracledb;
const { requireAuth, requireManager } = require('../middleware/auth');

// ใช้ Middleware ตรวจสอบ Login ทุก Route
router.use(requireAuth);

/**
 * GET /api/products
 * ดึงรายการสินค้าทั้งหมด พร้อมชื่อหมวดหมู่
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT p.Product_ID, p.Drug_type, p.Product_Name, p.Generic_Name,
                    p.Reorder_Point, p.Unit_Price, p.Unit_per_pack,
                    p.Category_ID, c.Category_Name,
                    NVL((SELECT SUM(b.Remaining_Qty) FROM Product_Batches b WHERE b.Product_ID = p.Product_ID), 0) AS Total_Stock
             FROM Product p
             LEFT JOIN Category c ON p.Category_ID = c.Category_ID
             ORDER BY p.Product_Name`
        );
        res.json(result.rows);
    } catch (err) {
        console.error('❌ ดึงข้อมูลสินค้าไม่ได้:', err);
        res.status(500).json({ error: 'ดึงข้อมูลสินค้าไม่ได้' });
    }
});

/**
 * GET /api/products/:id
 * ดึงข้อมูลสินค้าตัวเดียวตาม ID
 */
router.get('/:id', async (req, res) => {
    try {
        const id = req.params.id.trim();
        const result = await db.execute(
            `SELECT p.*, c.Category_Name 
             FROM Product p 
             LEFT JOIN Category c ON p.Category_ID = c.Category_ID 
             WHERE TRIM(p.Product_ID) = :id`,
            { id }
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'ไม่พบสินค้า' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error('❌ ดึงข้อมูลสินค้าไม่ได้:', err);
        res.status(500).json({ error: 'ดึงข้อมูลสินค้าไม่ได้' });
    }
});

/**
 * POST /api/products
 * เพิ่มสินค้าใหม่ ผ่าน sp_upsert_product (action = INSERT)
 */
router.post('/', requireManager, async (req, res) => {
    try {
        const { Product_ID, Drug_type, Product_Name, Generic_Name,
            Reorder_Point, Unit_Price, Unit_per_pack, Category_ID } = req.body;

        // ขั้นตอนที่ 1: เรียกใช้ Stored Procedure ชื่อ sp_upsert_product
        // การใช้คำสั่ง BEGIN ... END; เป็นไวยากรณ์มาตรฐานของ PL/SQL ใน Oracle
        const result = await db.execute(
            `BEGIN sp_upsert_product(:p_id, :p_type, :p_name, :p_generic, :p_reorder, :p_price, :p_pack, :p_cat, 'INSERT', :p_result); END;`,
            {
                // ขั้นตอนที่ 2: ผูกตัวแปร (Data Binding)
                // - dir: oracledb.BIND_INOUT หมายถึงส่งตัวแปรนี้เข้าไปทำงาน และรอรับค่าที่เปลี่ยนกลับมาด้วย 
                p_id: { val: Product_ID || null, dir: oracledb.BIND_INOUT, type: oracledb.STRING, maxSize: 20 },
                p_type: Drug_type, p_name: Product_Name,
                p_generic: Generic_Name, p_reorder: Reorder_Point,
                p_price: Unit_Price, p_pack: Unit_per_pack, p_cat: Category_ID,
                // - dir: oracledb.BIND_OUT สำหรับรับ Message ผลลัพธ์กลับมาจาก DB (เช่น "SUCCESS..." หรือ "ERROR...")
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) throw new Error(msg);
        res.status(201).json({ message: 'เพิ่มสินค้าสำเร็จ', Product_ID: result.outBinds.p_id });
    } catch (err) {
        console.error('❌ เพิ่มสินค้าไม่ได้:', err);
        res.status(500).json({ error: err.message || 'เพิ่มสินค้าไม่ได้' });
    }
});

/**
 * PUT /api/products/:id
 * แก้ไขข้อมูลสินค้า ผ่าน sp_upsert_product (action = UPDATE)
 */
router.put('/:id', requireManager, async (req, res) => {
    try {
        const { Drug_type, Product_Name, Generic_Name,
            Reorder_Point, Unit_Price, Unit_per_pack, Category_ID } = req.body;
        const id = req.params.id.trim();

        const result = await db.execute(
            `BEGIN sp_upsert_product(:p_id, :p_type, :p_name, :p_generic, :p_reorder, :p_price, :p_pack, :p_cat, 'UPDATE', :p_result); END;`,
            {
                p_id: { val: id, dir: oracledb.BIND_INOUT, type: oracledb.STRING, maxSize: 20 },
                p_type: Drug_type, p_name: Product_Name,
                p_generic: Generic_Name, p_reorder: Reorder_Point,
                p_price: Unit_Price, p_pack: Unit_per_pack, p_cat: Category_ID,
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) throw new Error(msg);
        res.json({ message: 'แก้ไขสินค้าสำเร็จ' });
    } catch (err) {
        console.error('❌ แก้ไขสินค้าไม่ได้:', err);
        res.status(500).json({ error: err.message || 'แก้ไขสินค้าไม่ได้' });
    }
});

/**
 * DELETE /api/products/:id
 * ลบสินค้า ผ่าน sp_delete_product (เช็ค integrity ใน procedure)
 */
router.delete('/:id', requireManager, async (req, res) => {
    try {
        const id = req.params.id.trim();
        const result = await db.execute(
            `BEGIN sp_delete_product(:p_id, :p_result); END;`,
            {
                p_id: id,
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) {
            return res.status(400).json({ error: msg.replace('ERROR: ', '') });
        }
        res.json({ message: 'ลบสินค้าสำเร็จ' });
    } catch (err) {
        console.error('❌ ลบสินค้าไม่ได้:', err);
        res.status(500).json({ error: 'ลบสินค้าไม่ได้' });
    }
});

module.exports = router;
