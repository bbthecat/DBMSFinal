// ============================================================
// Route: ระบบขายหน้าร้าน POS (Sales API)
// หน้าที่: รับคำสั่งตอนกด "ชำระเงิน" จากหน้าจอ POS แล้วส่งไปบันทึก
// จุดเด่นทางเทคนิค (DBMS Concept):
// 1. Transaction Management: รวบคำสั่งสร้างบิล (sp_create_sale) และ
//    คำสั่งตัดสต็อกแต่ละรายการยา (sp_add_sale_item) เข้าด้วยกัน
//    ทำสำเร็จต้อง Commit ถ้ามี Error กลางทางต้อง Rollback ทั้งหมดเพื่อรักษาความถูกต้อง
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const oracledb = db.oracledb;
const { requireAuth } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/sales
 * ดึงประวัติการขายทั้งหมด
 */
router.get('/', async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT sh.Sale_ID, TO_CHAR(sh.Sale_date, 'YYYY-MM-DD HH24:MI') AS Sale_date,
                    sh.Total_Amount, sh.EMP_ID,
                    e.First_Name || ' ' || e.Last_Name AS Emp_Name
             FROM Sales_Header sh
             LEFT JOIN Employees e ON sh.EMP_ID = e.EMP_ID
             ORDER BY sh.Sale_date DESC`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูลการขายไม่ได้' });
    }
});

/**
 * GET /api/sales/:id
 * ดึงรายละเอียดบิลขาย
 */
router.get('/:id', async (req, res) => {
    try {
        const id = req.params.id.trim();
        const header = await db.execute(
            `SELECT sh.*, e.First_Name || ' ' || e.Last_Name AS Emp_Name,
                    TO_CHAR(sh.Sale_date, 'YYYY-MM-DD HH24:MI') AS Sale_date_str
             FROM Sales_Header sh
             LEFT JOIN Employees e ON sh.EMP_ID = e.EMP_ID
             WHERE TRIM(sh.Sale_ID) = :id`,
            { id }
        );

        const details = await db.execute(
            `SELECT sd.*, pb.Lot_Number, p.Product_Name, p.Generic_Name
             FROM Sales_Detail sd
             LEFT JOIN Product_Batches pb ON sd.Batch_ID = pb.Batch_ID
             LEFT JOIN Product p ON pb.Product_ID = p.Product_ID
             WHERE TRIM(sd.Sale_ID) = :id`,
            { id }
        );

        res.json({
            header: header.rows[0],
            details: details.rows
        });
    } catch (err) {
        res.status(500).json({ error: 'ดึงรายละเอียดบิลขายไม่ได้' });
    }
});

/**
 * POST /api/sales
 * สร้างบิลขายใหม่ (POS) ผ่าน Stored Procedure
 * ใช้ sp_create_sale + sp_add_sale_item ในเดียว Transaction
 */
router.post('/', async (req, res) => {
    let conn;
    try {
        const { items } = req.body;
        const EMP_ID = req.session.user.EMP_ID;

        // ขั้นตอนที่ 1: ขอ Connection จาก Pool เปล่าๆ มาถือไว้ 
        // (ยังไม่สั่ง Auto-Commit เพื่อให้เราเขียนรวบคำสั่งเป็นก้อนเดียวกันได้)
        conn = await db.getConnection();

        // ขั้นตอนที่ 2: สร้างหัวบิล (Header) ด้วย sp_create_sale
        const headerResult = await conn.execute(
            `BEGIN sp_create_sale(:p_emp_id, :p_sale_id, :p_result); END;`,
            {
                p_emp_id: EMP_ID,
                // Oracle จะเจน Sale_ID กลับมาให้ที่ OutBind
                p_sale_id: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 20 },
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        if (!headerResult.outBinds.p_result.startsWith('SUCCESS')) {
            throw new Error(headerResult.outBinds.p_result);
        }

        const saleId = headerResult.outBinds.p_sale_id;

        // ขั้นตอนที่ 3: เอาบิลที่เพิ่งสร้าง มาวนลูปเพิ่มรายการยาเข้าไปทีละกล่อง
        // วงจรต้านปัญหา Concurrency: ถ้าของกล่องสุดท้ายในลูปหมด (Error จาก Procedure)
        // มันจะกระโดดเข้า catch (err) ทันที
        for (const item of items) {
            const itemResult = await conn.execute(
                `BEGIN sp_add_sale_item(:p_sale_id, :p_batch_id, :p_quantity, :p_unit_price, :p_discount, :p_detail_id, :p_result); END;`,
                {
                    p_sale_id: saleId,
                    p_batch_id: item.Batch_ID,
                    p_quantity: item.Quantity,
                    p_unit_price: item.Unit_Price,
                    p_discount: item.Discount || 0,
                    p_detail_id: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 20 },
                    p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
                }
            );

            if (!itemResult.outBinds.p_result.startsWith('SUCCESS')) {
                throw new Error(itemResult.outBinds.p_result);
            }
        }

        // ขั้นตอนที่ 4: หากทุกอย่างผ่านหมด (ไม่มี Error เด้ง) จะสั่งยืนยันเปลี่ยนแปลง
        await conn.commit();
        res.status(201).json({ message: 'บันทึกการขายสำเร็จ', Sale_ID: saleId });

    } catch (err) {
        // ขั้นตอนที่ 5 (ถ้าพังหนี้): ยกเลิกทั้งหมด (Rollback) เช่น เพิ่มของไปเเล้ว 2 ตัว พอตัวที่ 3 สต็อกหมด 
        // จะยกเลิกการสร้างบิลทั้งหมด คืนสต็อกทั้งหมดกลับที่เดิมทันที (Atomicity)
        if (conn) try { await conn.rollback(); } catch (e) { }
        console.error('❌ บันทึกการขายไม่ได้:', err);
        res.status(500).json({ error: err.message || 'บันทึกการขายไม่ได้' });
    } finally {
        if (conn) try { await conn.close(); } catch (e) { }
    }
});

module.exports = router;
