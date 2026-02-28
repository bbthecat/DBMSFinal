// ============================================================
// Route สำหรับจัดการล็อตสินค้า (Product Batches)
// ดูรายการ Batch, เช็คสินค้าใกล้หมดอายุ
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/batches
 * ดึงรายการ Batch ทั้งหมดพร้อมชื่อสินค้า
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT pb.Batch_ID, TO_CHAR(pb.MFG_date,'YYYY-MM-DD') AS MFG_date, 
                    TO_CHAR(pb.EXP_date,'YYYY-MM-DD') AS EXP_date,
                    pb.Cost_Price, pb.Lot_Number, pb.Received_Qty, pb.Remaining_Qty,
                    TO_CHAR(pb.Import_Date,'YYYY-MM-DD') AS Import_Date,
                    pb.Product_ID, p.Product_Name, p.Generic_Name,
                    pb.Purchase_ID,
                    CASE 
                        WHEN pb.EXP_date < SYSDATE THEN 'หมดอายุแล้ว'
                        WHEN pb.EXP_date < SYSDATE + 90 THEN 'ใกล้หมดอายุ'
                        ELSE 'ปกติ'
                    END AS Status
             FROM Product_Batches pb
             LEFT JOIN Product p ON pb.Product_ID = p.Product_ID
             ORDER BY pb.EXP_date ASC`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูล Batch ไม่ได้' });
    }
});

/**
 * GET /api/batches/available
 * ดึง Batch ที่ยังมีสินค้าคงเหลือ (สำหรับ POS)
 * เรียงตาม EXP ใกล้หมดก่อน (FEFO - First Expired First Out)
 */
router.get('/available', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT pb.Batch_ID, pb.Lot_Number, pb.Remaining_Qty,
                    TO_CHAR(pb.EXP_date,'YYYY-MM-DD') AS EXP_date,
                    pb.Product_ID, p.Product_Name, p.Generic_Name, p.Unit_Price,
                    p.Category_ID, c.Category_Name
             FROM Product_Batches pb
             LEFT JOIN Product p ON pb.Product_ID = p.Product_ID
             LEFT JOIN Category c ON p.Category_ID = c.Category_ID
             WHERE pb.Remaining_Qty > 0 AND pb.EXP_date > SYSDATE
             ORDER BY p.Product_Name, pb.EXP_date ASC`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูล Batch ไม่ได้' });
    }
});

module.exports = router;
