// ============================================================
// เซิร์ฟเวอร์หลัก - ระบบจัดการร้านยา
// Express.js + Oracle Database
// ============================================================
require('dotenv').config();
const express = require('express');
const session = require('express-session');
const cors = require('cors');
const path = require('path');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

// ============================================================
// ตั้งค่า Middleware
// ============================================================

// อนุญาต Cross-Origin Request
app.use(cors({ origin: true, credentials: true }));

// แปลง JSON body
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ตั้งค่า Session สำหรับเก็บข้อมูล Login
app.use(session({
    secret: process.env.SESSION_SECRET || 'pharmacy_secret',
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 8 * 60 * 60 * 1000  // Session หมดอายุใน 8 ชั่วโมง
    }
}));

// เสิร์ฟไฟล์ Static (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, 'public')));

// ============================================================
// ลงทะเบียน Routes ทั้งหมด
// ============================================================
app.use('/api', require('./routes/auth'));           // เข้าสู่ระบบ / ออกจากระบบ
app.use('/api/products', require('./routes/products'));       // จัดการสินค้า
app.use('/api/categories', require('./routes/categories'));   // จัดการหมวดหมู่
app.use('/api/employees', require('./routes/employees'));     // จัดการพนักงาน
app.use('/api/suppliers', require('./routes/suppliers'));     // จัดการ Supplier
app.use('/api/purchases', require('./routes/purchases'));     // จัดการใบสั่งซื้อ
app.use('/api/sales', require('./routes/sales'));             // ขาย / POS
app.use('/api/batches', require('./routes/batches'));         // ล็อตสินค้า
app.use('/api/dashboard', require('./routes/dashboard'));     // สรุปข้อมูล Dashboard
app.use('/api/reports', require('./routes/reports'));         // รายงาน / Audit Log

// ============================================================
// Route เริ่มต้น — ส่ง index.html
// ============================================================
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ============================================================
// เริ่มต้น Server + เชื่อมต่อ Database
// ============================================================
async function startServer() {
    try {
        // เชื่อมต่อฐานข้อมูล Oracle
        await db.initialize();

        // เปิด Server
        app.listen(PORT, () => {
            console.log('============================================');
            console.log(`🏥 ระบบร้านยาพร้อมใช้งานแล้ว!`);
            console.log(`🌐 เปิดเว็บ: http://localhost:${PORT}`);
            console.log('============================================');
        });
    } catch (err) {
        console.error('❌ เริ่มต้นระบบไม่ได้:', err);
        process.exit(1);
    }
}

// จัดการปิด Server อย่างถูกต้อง
process.on('SIGINT', async () => {
    console.log('\n🛑 กำลังปิดระบบ...');
    await db.close();
    process.exit(0);
});

// เริ่มเซิร์ฟเวอร์!
startServer();
