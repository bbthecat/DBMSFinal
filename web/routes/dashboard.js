// ============================================================
// Route สำหรับ Dashboard
// ใช้ Stored Procedure: sp_get_dashboard (SYS_REFCURSOR)
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const oracledb = db.oracledb;
const { requireAuth } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/dashboard
 * ดึงข้อมูลสรุปสำหรับหน้า Dashboard ผ่าน sp_get_dashboard
 * ใช้ SYS_REFCURSOR สำหรับข้อมูลที่เป็น list
 */
router.get('/', async (req, res) => {
    let conn;
    try {
        // ต้องใช้ Connection ตรงเพราะ Cursor ต้อง fetch ก่อนปิด
        conn = await db.getConnection();

        const result = await conn.execute(
            `BEGIN sp_get_dashboard(:p_today_revenue, :p_today_count, :p_product_count, :p_low_stock_cur, :p_expiring_cur, :p_recent_sales_cur); END;`,
            {
                p_today_revenue: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
                p_today_count: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
                p_product_count: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
                p_low_stock_cur: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR },
                p_expiring_cur: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR },
                p_recent_sales_cur: { dir: oracledb.BIND_OUT, type: oracledb.CURSOR }
            },
            { outFormat: oracledb.OUT_FORMAT_OBJECT }
        );

        const binds = result.outBinds;

        // ดึงข้อมูลจาก Cursor ทั้ง 3 ตัว
        const lowStockRows = await binds.p_low_stock_cur.getRows(100);
        await binds.p_low_stock_cur.close();

        const expiringRows = await binds.p_expiring_cur.getRows(100);
        await binds.p_expiring_cur.close();

        const recentSalesRows = await binds.p_recent_sales_cur.getRows(10);
        await binds.p_recent_sales_cur.close();

        res.json({
            todaySales: {
                TOTAL_REVENUE: binds.p_today_revenue,
                SALE_COUNT: binds.p_today_count
            },
            productCount: binds.p_product_count,
            lowStock: lowStockRows,
            expiringSoon: expiringRows,
            recentSales: recentSalesRows
        });

    } catch (err) {
        console.error('❌ ดึงข้อมูล Dashboard ไม่ได้:', err);
        res.status(500).json({ error: 'ดึงข้อมูล Dashboard ไม่ได้' });
    } finally {
        if (conn) try { await conn.close(); } catch (e) { }
    }
});

module.exports = router;
