// ============================================================
// Middleware ตรวจสอบการเข้าสู่ระบบ
// ใช้ครอบ Route ที่ต้องการให้ Login ก่อนใช้งาน
// ============================================================

/**
 * ตรวจสอบว่าผู้ใช้ Login แล้วหรือยัง
 * ถ้ายังไม่ Login จะส่ง 401 กลับไป
 */
function requireAuth(req, res, next) {
    if (req.session && req.session.user) {
        // ผ่านแล้ว → ไปต่อ
        return next();
    }
    // ยังไม่ได้ Login → ส่ง Error กลับ
    res.status(401).json({ error: 'กรุณาเข้าสู่ระบบก่อน' });
}

/**
 * ตรวจสอบว่าเป็นผู้จัดการหรือไม่ (สำหรับฟังก์ชันจัดการพนักงาน)
 */
function requireManager(req, res, next) {
    const pos = (req.session && req.session.user && req.session.user.POSITION) || '';
    // รองรับทั้งชื่อตำแหน่งภาษาไทยและอังกฤษ
    const managerRoles = ['ผู้จัดการ', 'Manager', 'Owner'];
    if (managerRoles.includes(pos)) {
        return next();
    }
    res.status(403).json({ error: 'คุณไม่มีสิทธิ์เข้าถึงส่วนนี้' });
}

module.exports = { requireAuth, requireManager };
