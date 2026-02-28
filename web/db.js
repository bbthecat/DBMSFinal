// ============================================================
// โมดูลเชื่อมต่อฐานข้อมูล Oracle
// ใช้ Connection Pool เพื่อประสิทธิภาพสูงสุด
// ============================================================
const oracledb = require('oracledb');

// กำหนดให้ส่งผลลัพธ์เป็น Object แทน Array
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// ตั้งค่า Auto Commit
oracledb.autoCommit = true;

let pool; // เก็บ Connection Pool ไว้ใช้ทั้งระบบ

/**
 * สร้าง Connection Pool สำหรับเชื่อมต่อ Oracle
 * เรียกครั้งเดียวตอนเริ่ม Server
 */
async function initialize() {
    try {
        pool = await oracledb.createPool({
            user: process.env.DB_USER,
            password: process.env.DB_PASS,
            connectString: process.env.DB_CONNECT_STRING,
            poolMin: 2,       // จำนวน Connection ขั้นต่ำ
            poolMax: 10,      // จำนวน Connection สูงสุด
            poolIncrement: 1  // เพิ่มทีละ 1 เมื่อไม่พอ
        });
        console.log('✅ เชื่อมต่อฐานข้อมูล Oracle สำเร็จ!');
    } catch (err) {
        console.error('❌ เชื่อมต่อฐานข้อมูลไม่ได้:', err);
        throw err;
    }
}

/**
 * ปิด Connection Pool ตอนปิด Server
 */
async function close() {
    try {
        await pool.close(0);
        console.log('🔌 ปิดการเชื่อมต่อฐานข้อมูลแล้ว');
    } catch (err) {
        console.error('❌ ปิด Connection Pool ไม่ได้:', err);
    }
}

/**
 * รัน SQL Query พร้อม bind parameters
 * @param {string} sql - คำสั่ง SQL
 * @param {object} binds - ค่า Parameters
 * @param {object} opts - ตัวเลือกเพิ่มเติม
 * @returns {object} ผลลัพธ์จาก Query
 */
async function execute(sql, binds = {}, opts = {}) {
    let connection;
    try {
        connection = await pool.getConnection();
        const result = await connection.execute(sql, binds, opts);
        return result;
    } catch (err) {
        console.error('❌ รัน SQL ไม่สำเร็จ:', err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close(); // คืน Connection กลับ Pool
            } catch (err) {
                console.error('❌ คืน Connection ไม่ได้:', err);
            }
        }
    }
}

/**
 * ดึง Connection จาก Pool สำหรับ Transaction
 * ผู้เรียกต้อง commit/rollback และ close เอง
 * @returns {object} Oracle Connection
 */
async function getConnection() {
    return await pool.getConnection();
}

module.exports = { initialize, close, execute, getConnection, oracledb };
