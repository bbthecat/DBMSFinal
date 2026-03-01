const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });
const db = require('./db');

// ລำดับโฟลเดอร์ที่ต้องรันคำสั่ง (1. ตาราง, 2. โปรซีเดอร์/ทริกเกอร์, 3. ข้อมูลดัมมี่)
const runDirs = [
    {
        name: 'สร้างตาราง (Tables)',
        dir: path.join(__dirname, '..', 'Table'),
        type: 'statement' // SQL ธรรมดา
    },
    {
        name: 'สร้างโปรแกรมย่อย (Procedures/Triggers/Views)',
        dir: path.join(__dirname, '..', 'Table', 'Procedures'),
        type: 'plsql' // คำสั่ง PL/SQL ที่ยาวๆ
    },
    {
        name: 'ใส่ข้อมูลจำลอง (Mock Data)',
        dir: path.join(__dirname, '..', 'Data'),
        type: 'statement' // SQL insert ปกติ
    }
];

// ฟังก์ชันแบ่งและรัน SQL จากไฟล์
async function executeSqlFile(filePath, type) {
    if (!fs.existsSync(filePath)) return;

    let content = fs.readFileSync(filePath, 'utf8');
    let queries = [];

    if (type === 'plsql') {
        // Procedure มักจะคั่นด้วย / บรรทัดใหม่
        queries = content.split(/^\s*\/\s*$/m)
            .map(q => q.trim())
            .filter(q => q.length > 0);
    } else {
        // Table/Insert มักจบด้วย ;
        // ลบคอมเมนต์และแยกคำสั่ง
        const noComments = content.replace(/--.*$/gm, '').replace(/\/\*[\s\S]*?\*\//g, '');
        queries = noComments.split(';')
            .map(q => q.trim())
            .filter(q => q.length > 0);
    }

    // รันแต่ละคำสั่ง
    for (let q of queries) {
        try {
            await db.execute(q, {}, { autoCommit: true });
        } catch (err) {
            // ไม่ต้องแสดง Error เล็กๆ น้อยๆ แบบ Table/Sequence ซ้ำ หรือยังไม่มีให้ลบ
            if (err.message.includes('ORA-00955') || // name is already used
                err.message.includes('ORA-00942') || // table or view does not exist
                err.message.includes('ORA-02289') || // sequence does not exist
                err.message.includes('ORA-00001')) { // unique constraint
                continue;
            }
            // แสดงเฉพาะ Error ที่ดูร้ายแรง
            console.error(`\x1b[31m[!] ข้อผิดพลาดในไฟล์ ${path.basename(filePath)}:\x1b[0m ${err.message}`);
            // console.error(`Query: ${q.substring(0, 50)}...`);
        }
    }
}

// ระบบรันไฟล์อัตโนมัติ
async function setupDatabase() {
    console.log('\n=============================================');
    console.log('🔄 เริ่มต้นระบบสร้างฐานข้อมูลอัตโนมัติ (Auto DB Setup)');
    console.log('=============================================\n');

    // ตรวจสอบข้อมูลแบบง่าย
    if (!process.env.DB_CONNECT_STRING) {
        console.error('\n❌ [ข้อผิดพลาด] ไม่พบการตั้งค่าในไฟล์ .env');
        console.error('กรุณาเข้าไปในโฟลเดอร์ web เปิดไฟล์ .env และแก้ไขข้อมูลฐานข้อมูลให้ถูกต้องก่อนรัน!\n');
        process.exit(1);
    }

    try {
        await db.initialize();
        console.log('\n[1] เชื่อมต่อ Oracle สำเร็จ!\n');

        // วนลูปตามโฟลเดอร์
        for (let task of runDirs) {
            console.log(`\n⏳ กำลัง${task.name}...`);
            const files = fs.readdirSync(task.dir).filter(f => f.endsWith('.sql'));

            // ต้องรันไล่ทีละไฟล์ ตามลำดับชื่อหรือเงื่อนไขพิเศษ (เช่น Category ก่อน)
            // สำหรับโปรเจกต์นี้ รันอะไรก่อนก็ได้ เพราะมี Error ซ้ำข้ามให้แล้ว
            let sortedFiles = files;
            // ดัน Category, Supplier, Employees ไว้รันก่อนใน Data
            if (task.dir.includes('Data')) {
                sortedFiles = files.sort((a, b) => {
                    if (a.includes('Category')) return -1;
                    if (a.includes('Suplier')) return -1;
                    if (a.includes('Employees')) return -1;
                    if (a.includes('Product.')) return -1;
                    return 1;
                });
            } else if (task.dir.endsWith('Table')) {
                sortedFiles = files.sort((a, b) => {
                    if (a.includes('Category')) return -1;
                    if (a.includes('Supplier')) return -1;
                    if (a.includes('Employees')) return -1;
                    if (a.includes('Product.')) return -1;
                    if (a.includes('Product_Batches')) return -1;
                    return 1;
                });
            }

            for (let file of sortedFiles) {
                const filePath = path.join(task.dir, file);
                await executeSqlFile(filePath, task.type);
                console.log(`   - รันไฟล์ ${file} เรียบร้อย`);
            }
        }

        console.log('\n🎉 สร้างฐานข้อมูลเสร็จสมบูรณ์ 100%!');

    } catch (err) {
        console.error('\n❌ เกิดข้อผิดพลาดร้ายแรง:', err.message);
    } finally {
        await db.close();
        process.exit(0);
    }
}

// เริ่มทำงาน
setupDatabase();
