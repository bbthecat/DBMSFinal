// ============================================================
// Route สำหรับจัดการหมวดหมู่ยา (Category)
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth, requireManager } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/categories
 * ดึงหมวดหมู่ทั้งหมด
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM Category ORDER BY Category_ID`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูลหมวดหมู่ไม่ได้' });
    }
});

/**
 * POST /api/categories
 * เพิ่มหมวดหมู่ใหม่
 */
router.post('/', async (req, res) => {
    try {
        const { Category_ID, Category_Name } = req.body;
        await db.execute(
            `INSERT INTO Category VALUES (:Category_ID, :Category_Name)`,
            { Category_ID, Category_Name }
        );
        res.status(201).json({ message: 'เพิ่มหมวดหมู่สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'เพิ่มหมวดหมู่ไม่ได้' });
    }
});

/**
 * PUT /api/categories/:id
 * แก้ไขหมวดหมู่
 */
router.put('/:id', async (req, res) => {
    try {
        const { Category_Name } = req.body;
        const id = req.params.id.trim();
        await db.execute(
            `UPDATE Category SET Category_Name = :Category_Name WHERE TRIM(Category_ID) = :id`,
            { Category_Name, id }
        );
        res.json({ message: 'แก้ไขหมวดหมู่สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'แก้ไขหมวดหมู่ไม่ได้' });
    }
});

/**
 * DELETE /api/categories/:id
 * ลบหมวดหมู่
 */
router.delete('/:id', requireManager, async (req, res) => {
    try {
        const id = req.params.id.trim();
        const check = await db.execute(
            `SELECT COUNT(*) AS CNT FROM Product WHERE TRIM(Category_ID) = :id`,
            { id }
        );
        if (check.rows[0].CNT > 0) {
            return res.status(400).json({ error: 'ไม่สามารถลบได้ มีสินค้าในหมวดนี้' });
        }
        await db.execute(
            `DELETE FROM Category WHERE TRIM(Category_ID) = :id`,
            { id }
        );
        res.json({ message: 'ลบหมวดหมู่สำเร็จ' });
    } catch (err) {
        res.status(500).json({ error: 'ลบหมวดหมู่ไม่ได้' });
    }
});

module.exports = router;
