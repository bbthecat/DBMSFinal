// ============================================================
// Route สำหรับรายงาน (Reports)
// ยอดขายรายเดือน, สต็อกสรุป, สินค้าขายดี, audit log
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/reports/monthly-sales
 * ยอดขายรายเดือน (6 เดือนล่าสุด)
 */
router.get('/monthly-sales', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM (
                SELECT TO_CHAR(sh.Sale_date, 'YYYY-MM') AS SALE_MONTH,
                       COUNT(*) AS SALE_COUNT,
                       NVL(SUM(sh.Total_Amount), 0) AS TOTAL_REVENUE
                FROM Sales_Header sh
                GROUP BY TO_CHAR(sh.Sale_date, 'YYYY-MM')
                ORDER BY SALE_MONTH ASC
            ) WHERE ROWNUM <= 12`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงรายงานยอดขายรายเดือนไม่ได้' });
    }
});

/**
 * GET /api/reports/top-products
 * สินค้าขายดี Top 10
 */
router.get('/top-products', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM (
                SELECT p.Product_Name,
                       SUM(sd.Quantity) AS TOTAL_SOLD,
                       SUM(sd.Subtotal) AS TOTAL_REVENUE
                FROM Sales_Detail sd
                JOIN Product_Batches pb ON sd.Batch_ID = pb.Batch_ID
                JOIN Product p ON pb.Product_ID = p.Product_ID
                GROUP BY p.Product_Name
                ORDER BY TOTAL_SOLD DESC
            ) WHERE ROWNUM <= 10`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงสินค้าขายดีไม่ได้' });
    }
});

/**
 * GET /api/reports/stock-summary
 * สรุปสต็อกทั้งหมด
 */
router.get('/stock-summary', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT p.Product_ID, p.Product_Name, p.Generic_Name,
                    c.Category_Name, p.Unit_Price, p.Reorder_Point,
                    NVL(SUM(pb.Remaining_Qty), 0) AS TOTAL_STOCK,
                    COUNT(pb.Batch_ID) AS BATCH_COUNT,
                    CASE 
                        WHEN NVL(SUM(pb.Remaining_Qty), 0) = 0 THEN 'OUT'
                        WHEN NVL(SUM(pb.Remaining_Qty), 0) < p.Reorder_Point THEN 'LOW'
                        ELSE 'OK'
                    END AS STOCK_STATUS
             FROM Product p
             LEFT JOIN Category c ON p.Category_ID = c.Category_ID
             LEFT JOIN Product_Batches pb ON p.Product_ID = pb.Product_ID
             GROUP BY p.Product_ID, p.Product_Name, p.Generic_Name,
                      c.Category_Name, p.Unit_Price, p.Reorder_Point
             ORDER BY TOTAL_STOCK ASC`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงสรุปสต็อกไม่ได้' });
    }
});

/**
 * GET /api/reports/audit-log
 * ประวัติการเปลี่ยนแปลงสินค้า (Audit Trail)
 */
router.get('/audit-log', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM (
                SELECT Log_ID, Action_Type, TRIM(Product_ID) AS Product_ID, Product_Name,
                       Changed_By, TO_CHAR(Changed_At, 'YYYY-MM-DD HH24:MI:SS') AS Changed_At,
                       Old_Price, New_Price, Details
                FROM Product_Audit_Log
                ORDER BY Changed_At DESC
            ) WHERE ROWNUM <= 50`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึง Audit Log ไม่ได้' });
    }
});

/**
 * GET /api/reports/stock-alerts
 * ประวัติแจ้งเตือนสต็อกต่ำ
 */
router.get('/stock-alerts', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT * FROM (
                SELECT Alert_ID, TRIM(Product_ID) AS Product_ID, Product_Name,
                       Current_Stock, Reorder_Point,
                       TO_CHAR(Alert_Date, 'YYYY-MM-DD HH24:MI') AS Alert_Date
                FROM Stock_Alert_Log
                ORDER BY Alert_Date DESC
            ) WHERE ROWNUM <= 50`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึง Stock Alerts ไม่ได้' });
    }
});

module.exports = router;
