// ============================================================
// Route สำหรับจัดการพนักงาน (Employees)
// ใช้ Stored Procedure: sp_upsert_employee, sp_delete_employee
// เฉพาะ Manager/Owner เท่านั้นที่จัดการได้
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');
const oracledb = db.oracledb;
const { requireAuth, requireManager } = require('../middleware/auth');

router.use(requireAuth);

/**
 * GET /api/employees
 * ดึงรายชื่อพนักงานทั้งหมด (ไม่แสดงรหัสผ่าน)
 */
router.get('/', requireManager, async (req, res) => {
    try {
        const result = await db.execute(
            `SELECT EMP_ID, Username, Position, First_Name, Last_Name 
             FROM Employees ORDER BY First_Name`
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'ดึงข้อมูลพนักงานไม่ได้' });
    }
});

/**
 * POST /api/employees
 * เพิ่มพนักงานใหม่ ผ่าน sp_upsert_employee (action = INSERT)
 */
router.post('/', requireManager, async (req, res) => {
    try {
        const { EMP_ID, Username, Password_Hash, Position, First_Name, Last_Name } = req.body;

        const result = await db.execute(
            `BEGIN sp_upsert_employee(:p_id, :p_user, :p_pass, :p_pos, :p_fname, :p_lname, 'INSERT', :p_result); END;`,
            {
                p_id: { val: EMP_ID || null, dir: oracledb.BIND_INOUT, type: oracledb.STRING, maxSize: 20 },
                p_user: Username, p_pass: Password_Hash,
                p_pos: Position, p_fname: First_Name, p_lname: Last_Name,
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) throw new Error(msg);
        res.status(201).json({ message: 'เพิ่มพนักงานสำเร็จ', EMP_ID: result.outBinds.p_id });
    } catch (err) {
        console.error('❌ เพิ่มพนักงานไม่ได้:', err);
        res.status(500).json({ error: err.message || 'เพิ่มพนักงานไม่ได้' });
    }
});

/**
 * PUT /api/employees/:id
 * แก้ไขข้อมูลพนักงาน ผ่าน sp_upsert_employee (action = UPDATE)
 */
router.put('/:id', requireManager, async (req, res) => {
    try {
        const { Username, Position, First_Name, Last_Name, Password_Hash } = req.body;
        const id = req.params.id.trim();

        const result = await db.execute(
            `BEGIN sp_upsert_employee(:p_id, :p_user, :p_pass, :p_pos, :p_fname, :p_lname, 'UPDATE', :p_result); END;`,
            {
                p_id: { val: id, dir: oracledb.BIND_INOUT, type: oracledb.STRING, maxSize: 20 },
                p_user: Username,
                p_pass: Password_Hash || null,
                p_pos: Position, p_fname: First_Name, p_lname: Last_Name,
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) throw new Error(msg);
        res.json({ message: 'แก้ไขข้อมูลพนักงานสำเร็จ' });
    } catch (err) {
        console.error('❌ แก้ไขพนักงานไม่ได้:', err);
        res.status(500).json({ error: err.message || 'แก้ไขพนักงานไม่ได้' });
    }
});

/**
 * DELETE /api/employees/:id
 * ลบพนักงาน ผ่าน sp_delete_employee (เช็ค integrity ใน procedure)
 */
router.delete('/:id', requireManager, async (req, res) => {
    try {
        const id = req.params.id.trim();
        const result = await db.execute(
            `BEGIN sp_delete_employee(:p_id, :p_result); END;`,
            {
                p_id: id,
                p_result: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );

        const msg = result.outBinds.p_result;
        if (!msg.startsWith('SUCCESS')) {
            return res.status(400).json({ error: msg.replace('ERROR: ', '') });
        }
        res.json({ message: 'ลบพนักงานสำเร็จ' });
    } catch (err) {
        console.error('❌ ลบพนักงานไม่ได้:', err);
        res.status(500).json({ error: 'ลบพนักงานไม่ได้' });
    }
});

module.exports = router;
