// ============================================================
// Route สำหรับจัดการใบสั่งซื้อ (Purchase)
// ใช้ Stored Procedure: sp_create_purchase, sp_add_purchase_item, sp_receive_purchase
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const oracledb = db.oracledb;
const { requireAuth, requireManager } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/purchases
 * ดึงรายการใบสั่งซื้อทั้งหมด พร้อมชื่อ Supplier และพนักงาน
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT ph.Purchase_ID, ph.Status, ph.Invoice_Number, 
                    TO_CHAR(ph.Purchase_Date, 'YYYY-MM-DD') AS Purchase_Date, 
                    ph.Total_Cost, ph.Supplier_ID, s.Supplier_Name,
                    ph.EMP_ID, e.First_Name || ' ' || e.Last_Name AS Emp_Name
             FROM Purchase_Header ph
             LEFT JOIN Supplier s ON ph.Supplier_ID = s.Supplier_ID
             LEFT JOIN Employees e ON ph.EMP_ID = e.EMP_ID
             ORDER BY ph.Purchase_Date DESC`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูลใบสั่งซื้อไม่ได้' });
    }
});

/**
 * GET /api/purchases/:id
 * ดึงรายละเอียดใบสั่งซื้อพร้อมรายการสินค้า
 */
router.get('/:id', async (req, res) => {
    try {
        const id = req.params.id.trim();
        const header = await db.execute(
            `SELECT ph.*, s.Supplier_Name, e.First_Name || ' ' || e.Last_Name AS Emp_Name,
                    TO_CHAR(ph.Purchase_Date, 'YYYY-MM-DD') AS Purchase_Date_Str
             FROM Purchase_Header ph
             LEFT JOIN Supplier s ON ph.Supplier_ID = s.Supplier_ID
             LEFT JOIN Employees e ON ph.EMP_ID = e.EMP_ID
             WHERE TRIM(ph.Purchase_ID) = :id`,
            { id }
        );
        if (header.rows.length === 0) {
            return res.status(404).json({ error: 'ไม่พบใบสั่งซื้อ' });
        }

        const details = await db.execute(
            `SELECT pd.*, p.Product_Name, p.Generic_Name,
                    TO_CHAR(pb.MFG_date, 'DD/MM/YYYY') AS MFG_DATE,
                    TO_CHAR(pb.EXP_date, 'DD/MM/YYYY') AS EXP_DATE,
                    TRIM(pb.Lot_Number) AS LOT_NUMBER
             FROM Purchase_Detail pd
             LEFT JOIN Product p ON pd.Product_ID = p.Product_ID
             LEFT JOIN Product_Batches pb
                    ON TRIM(pb.Purchase_ID) = TRIM(pd.Purchase_ID)
                   AND TRIM(pb.Product_ID)  = TRIM(pd.Product_ID)
             WHERE TRIM(pd.Purchase_ID) = :id`,
            { id }
        );

        res.json({
            header: header.rows[0],
            details: details.rows
        });
    } catch (err) {
        res.status(500).json({ error: 'ดึงรายละเอียดใบสั่งซื้อไม่ได้' });
    }
});

/**
 * POST /api/purchases
 * สร้างใบสั่งซื้อใหม่ ผ่าน Stored Procedure
 * ใช้ sp_create_purchase + sp_add_purchase_item
 */
router.post('/', requireManager, async (req, res) => {
    let conn;
    try {
        const { Invoice_Number, Purchase_Date, Supplier_ID, items } = req.body;
        const EMP_ID = req.session.user.EMP_ID;

        // format date as string
        const pDateStr = Purchase_Date ? Purchase_Date : new Date().toISOString().split('T')[0];

        let totalCost = 0;
        items.forEach(item => { totalCost += item.Order_Qty * item.Cost_Price; });

        conn = await db.getConnection();

        // 1. sp_create_purchase → Purchase_ID สร้างจาก Sequence
        const headerResult = await conn.execute(
            `BEGIN sp_create_purchase(:p_invoice, :p_supplier_id, :p_emp_id, :p_total_cost, TO_DATE(:p_purchase_date, 'YYYY-MM-DD'), :p_purchase_id, :p_result); END;`,
            {
                p_invoice: Invoice_Number,
                p_supplier_id: Supplier_ID,
                p_emp_id: EMP_ID,
                p_total_cost: totalCost,
                p_purchase_date: pDateStr,
                p_purchase_id: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 20 },
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        if (!headerResult.outBinds.p_result.startsWith('SUCCESS')) {
            throw new Error(headerResult.outBinds.p_result);
        }

        const purchaseId = headerResult.outBinds.p_purchase_id;

        // 2. sp_add_purchase_item → Detail_ID สร้างจาก Sequence
        for (const item of items) {
            const itemResult = await conn.execute(
                `BEGIN sp_add_purchase_item(:p_purchase_id, :p_product_id, :p_order_qty, :p_cost_price, :p_detail_id, :p_result); END;`,
                {
                    p_purchase_id: purchaseId,
                    p_product_id: item.Product_ID,
                    p_order_qty: item.Order_Qty,
                    p_cost_price: item.Cost_Price,
                    p_detail_id: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 20 },
                    p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
                }
            );

            if (!itemResult.outBinds.p_result.startsWith('SUCCESS')) {
                throw new Error(itemResult.outBinds.p_result);
            }
        }

        await conn.commit();
        res.status(201).json({ message: 'สร้างใบสั่งซื้อสำเร็จ', Purchase_ID: purchaseId });

    } catch (err) {
        if (conn) try { await conn.rollback(); } catch (e) { }
        console.error('❌ สร้างใบสั่งซื้อไม่ได้:', err);
        res.status(500).json({ error: err.message || 'สร้างใบสั่งซื้อไม่ได้' });
    } finally {
        if (conn) try { await conn.close(); } catch (e) { }
    }
});

/**
 * GET /api/purchases/:id/items
 * ดึงรายการสินค้าใน Purchase_Detail เพื่อให้ Frontend แสดงฟอร์มกรอก Lot/EXP ต่อ item
 */
router.get('/:id/items', async (req, res) => {
    try {
        const id = req.params.id.trim();
        const result = await db.execute(
            `SELECT pd.P_Detail_ID, pd.Product_ID, pd.Order_Qty, pd.Cost_Price,
                    p.Product_Name
             FROM Purchase_Detail pd
             LEFT JOIN Product p ON pd.Product_ID = p.Product_ID
             WHERE TRIM(pd.Purchase_ID) = :id
             ORDER BY pd.P_Detail_ID`,
            { id }
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงรายการสินค้าไม่ได้' });
    }
});

/**
 * PUT /api/purchases/:id/receive
 * รับสินค้าจาก Supplier ผ่าน sp_receive_purchase (ต่อ item)
 * Body: { items: [{ detail_id, lot_number, mfg_date, exp_date }] }
 * วน loop เรียก SP ทีละ item พร้อมข้อมูล Lot/EXP จริง
 */
router.put('/:id/receive', requireManager, async (req, res) => {
    let conn;
    try {
        const id = req.params.id.trim();
        const { items } = req.body; // รับ array ของ item พร้อม lot/date

        if (!items || items.length === 0) {
            return res.status(400).json({ error: 'ไม่มีรายการสินค้า' });
        }

        conn = await db.getConnection();

        let successCount = 0;
        for (let i = 0; i < items.length; i++) {
            const item = items[i];
            const isLast = (i === items.length - 1); // item สุดท้าย → อัพเดทสถานะบิล

            const result = await conn.execute(
                `BEGIN sp_receive_purchase(
                    :p_purchase_id,
                    :p_detail_id,
                    :p_lot_number,
                    TO_DATE(:p_mfg_date, 'YYYY-MM-DD'),
                    TO_DATE(:p_exp_date, 'YYYY-MM-DD'),
                    :p_counter,
                    :p_update_status,
                    :p_result
                ); END;`,
                {
                    p_purchase_id: id,
                    p_detail_id: String(item.detail_id).trim(),
                    p_lot_number: item.lot_number || ('LOT' + new Date().toISOString().slice(2, 8).replace(/-/g, '')),
                    p_mfg_date: item.mfg_date,
                    p_exp_date: item.exp_date,
                    p_counter: i + 1,
                    p_update_status: isLast ? 'Y' : 'N',
                    p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
                }
            );

            const msg = result.outBinds.p_result;
            if (!msg.startsWith('SUCCESS')) {
                throw new Error(msg);
            }
            successCount++;
        }

        await conn.commit();
        res.json({ message: `รับสินค้าสำเร็จ! สร้าง ${successCount} Batch เรียบร้อย` });

    } catch (err) {
        if (conn) try { await conn.rollback(); } catch (e) { }
        console.error('❌ รับสินค้าไม่ได้:', err);
        res.status(500).json({ error: err.message || 'รับสินค้าไม่ได้' });
    } finally {
        if (conn) try { await conn.close(); } catch (e) { }
    }
});

/**
 * PUT /api/purchases/:id/status
 * อัพเดทสถานะใบสั่งซื้อ (เช่น รอรับสินค้า → ยกเลิก)
 */
router.put('/:id/status', requireManager, async (req, res) => {
    try {
        const { Status } = req.body;
        const id = req.params.id.trim();
        await db.execute(
            `UPDATE Purchase_Header SET Status = :Status WHERE TRIM(Purchase_ID) = :id`,
            { Status, id }
        );
        res.json({ message: 'อัพเดทสถานะสำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'อัพเดทสถานะไม่ได้' });
    }
});

module.exports = router;
