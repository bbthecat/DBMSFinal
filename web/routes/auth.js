// ============================================================
// Route สำหรับการเข้าสู่ระบบ / ออกจากระบบ
// ตรวจสอบ Username + Password กับตาราง Employees
// ============================================================
const express = require('express');
const router = express.Router();
const db = require('../db');

/**
 * POST /api/login
 * รับ username, password แล้วเช็คกับฐานข้อมูล
 */
router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;

        // ตรวจสอบว่ากรอกข้อมูลครบ
        if (!username || !password) {
            return res.status(400).json({ error: 'กรุณากรอก Username และ Password' });
        }

        // ค้นหาผู้ใช้จากตาราง Employees ด้วย Username
        const result = await db.execute(
            `SELECT EMP_ID, Username, Password_Hash, Position, First_Name, Last_Name 
             FROM Employees 
             WHERE LOWER(Username) = LOWER(:username)`,
            { username }
        );

        // ไม่เจอ Username
        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง' });
        }

        const user = result.rows[0];

        // เช็ครหัสผ่าน (เทียบ plain text สำหรับ demo)
        if (password !== user.PASSWORD_HASH.trim()) {
            return res.status(401).json({ error: 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง' });
        }

        // เก็บข้อมูลผู้ใช้ใน Session
        req.session.user = {
            EMP_ID: user.EMP_ID.trim(),
            USERNAME: user.USERNAME.trim(),
            POSITION: user.POSITION,
            FIRST_NAME: user.FIRST_NAME,
            LAST_NAME: user.LAST_NAME
        };

        // ส่งข้อมูลผู้ใช้กลับ (ไม่ส่งรหัสผ่าน)
        res.json({
            message: 'เข้าสู่ระบบสำเร็จ',
            user: req.session.user
        });

    } catch (err) {
        console.error('❌ Login Error:', err);
        res.status(500).json({ error: 'เกิดข้อผิดพลาดในระบบ' });
    }
});

/**
 * POST /api/logout
 * ล้าง Session แล้วส่ง redirect
 */
router.post('/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).json({ error: 'ออกจากระบบไม่สำเร็จ' });
        }
        res.json({ message: 'ออกจากระบบแล้ว' });
    });
});

/**
 * GET /api/me
 * ดึงข้อมูลผู้ใช้ที่ Login อยู่
 */
router.get('/me', (req, res) => {
    if (req.session && req.session.user) {
        res.json({ user: req.session.user });
    } else {
        res.status(401).json({ error: 'ยังไม่ได้เข้าสู่ระบบ' });
    }
});

module.exports = router;
