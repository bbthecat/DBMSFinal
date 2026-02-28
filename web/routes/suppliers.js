// ============================================================
// Route สำหรับจัดการผู้จัดจำหน่าย (Supplier)
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth, requireManager } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/suppliers
 * ดึงรายชื่อ Supplier ทั้งหมด
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM Supplier ORDER BY Supplier_ID`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูล Supplier ไม่ได้' });
    }
});

/**
 * POST /api/suppliers
 * เพิ่ม Supplier ใหม่
 */
router.post('/', async (req, res) => {
    try {
        const { Supplier_ID, Supplier_Name, Contract } = req.body;
        await db.execute(
            `INSERT INTO Supplier VALUES (:Supplier_ID, :Supplier_Name, :Contract)`,
            { Supplier_ID, Supplier_Name, Contract }
        );
        res.status(201).json({ message: 'เพิ่ม Supplier สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'เพิ่ม Supplier ไม่ได้' });
    }
});

/**
 * PUT /api/suppliers/:id
 * แก้ไขข้อมูล Supplier
 */
router.put('/:id', async (req, res) => {
    try {
        const { Supplier_Name, Contract } = req.body;
        const id = req.params.id.trim();
        await db.execute(
            `UPDATE Supplier SET Supplier_Name = :Supplier_Name, Contract = :Contract 
             WHERE TRIM(Supplier_ID) = :id`,
            { Supplier_Name, Contract, id }
        );
        res.json({ message: 'แก้ไข Supplier สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'แก้ไข Supplier ไม่ได้' });
    }
});

/**
 * DELETE /api/suppliers/:id
 * ลบ Supplier
 */
router.delete('/:id', requireManager, async (req, res) => {
    try {
        const id = req.params.id.trim();
        const check = await db.execute(
            `SELECT COUNT(*) AS CNT FROM Purchase_Header WHERE TRIM(Supplier_ID) = :id`,
            { id }
        );
        if (check.rows[0].CNT > 0) {
            return res.status(400).json({ error: 'ไม่สามารถลบได้ มีใบสั่งซื้ออ้างอิง' });
        }
        await db.execute(
            `DELETE FROM Supplier WHERE TRIM(Supplier_ID) = :id`,
            { id }
        );
        res.json({ message: 'ลบ Supplier สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'ลบ Supplier ไม่ได้' });
    }
});

module.exports = router;
