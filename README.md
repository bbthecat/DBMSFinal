# 🏥 Pharmacy Management System (ระบบบริหารจัดการร้านยา)

โปรเจกต์ระบบบริหารจัดการร้านยาแบบครบวงจร (Web Application) ออกแบบมาสำหรับการทำงานจริงในร้านยา รองรับระบบขายหน้าร้าน ระบบจัดการคลังสินค้าแบบรายล็อต และระบบการสั่งซื้อสินค้า

ระบบนี้พัฒนาขึ้นเพื่อเป็นโปรเจกต์ในรายวิชา **Database Management System (DBMS)** โดยเน้นอิมพลีเมนต์โครงสร้างฐานข้อมูลที่มีความซับซ้อน เช่น การใช้งาน Stored Procedures, Triggers, Views และ Foreign Keys อย่างเต็มรูปแบบ

---

## 💻 Tech Stack
- **Frontend:** HTML5, CSS3 (Vanilla), JavaScript, Chart.js (สำหรับ Dashboard)
- **Backend:** Node.js (Express.js)
- **Database:** Oracle Database (Express Edition 21c)
- **Driver:** `oracledb` (Node.js Connector)

---

## ✨ ฟีเจอร์เด่น (Key Features)

1. 🛒 **POS (Point of Sale) - ระบบขายหน้าร้าน:**
   - ค้นหายาได้รวดเร็ว (รองรับชื่อสามัญ และชื่อการค้า)
   - เพิ่มสินค้าลงตะกร้า คำนวณยอดเงินและเงินทอนอัตโนมัติ
   - **ระบบตัดสต็อกขั้นสูงแบบ FIFO (First-In, First-Out):** เมื่อขายยา ระบบจะตัดยอดจากล็อตที่ "วันหมดอายุใกล้ที่สุด" (Earliest Expiry) หรือ "นำเข้าก่อน" อัตโนมัติ

2. 📦 **Inventory & Product Batches - ระบบคลังสินค้าผ่าน Batch:**
   - สินค้า 1 ชนิด สามารถมีข้อมูลหลายล็อต (Batch) ได้ 
   - ระบบแจ้งเตือนสต็อกเหลือน้อย (อ้างอิงจากยอดรวมทุกล็อตเทียบกับ Reorder Point)
   - หน้า UI แบบ Grouping ช่วยให้ดูง่ายว่ายาแต่ละตัว คงเหลือล็อตไหนบ้าง วันหมดอายุเมื่อไหร่
   - รองรับสถานะยา (ปกติ, ใกล้หมดอายุ, หมดอายุแล้ว) แบบเรียลไทม์

3. 🚚 **Purchasing - ระบบจัดซื้อสินค้า:**
   - บันทึกการสั่งซื้อ (PO) จาก Supplier
   - ฟีเจอร์ "รับสินค้า (Receive)": เมื่อยืนยันรับเข้า ระบบจะเปลี่ยนสถานะบิล และทำการเพิ่ม "ล็อตใหม่ (Product Batches)" ของยาเข้าคลังสินค้าอัตโนมัติ

4. 📊 **Dashboard & Reports:**
   - สรุปยอดขายรายวันและยอดขายรวม
   - สรุปสินค้ายอดฮิต (Best Sellers)
   - พิมพ์ใบเสร็จย้อนหลัง (Receipt)

5. 👥 **Master Data Management:**
   - ระบบจัดการพนักงาน, ผู้จัดจำหน่าย (Supplier), หมวดหมู่ยา และข้อมูลยา (Drugs Catalog)

---

## �️ โครงสร้างฐานข้อมูล (Database Design)

ระบบฐานข้อมูลออกแบบมาอย่างรัดกุมด้วย Oracle Database
> ไฟล์ Source Code และ SQL ทั้งหมดอยู่ที่โฟลเดอร์ `/Table` และ `/Data`

- **Tables (ตารางหลัก):** 
  `Employees`, `Category`, `Supplier`, `Product`, `Product_Batches`, `Purchase_Header`, `Purchase_Detail`, `Sales_Header`, `Sales_Detail`
- **Stored Procedures:** (เขียนไว้ฝั่ง DB เพื่อความรวดเร็วและปลอดภัย)
  - `sp_create_sale` / `sp_add_sale_item`: สำหรับบันทึกบิลขายและตัดสต็อก FIFO
  - `sp_create_purchase` / `sp_add_purchase_item`: สำหรับเปิดใบสั่งซื้อ
  - `sp_receive_purchase`: จัดการปิดบิลซื้อและเพิ่มล็อตสินค้าเข้าคลังอัตโนมัติ
  - `sp_get_dashboard`: ดึงชุดข้อมูลทั้งหมดสำหรับหน้า Dashboard ผ่าน SYS_REFCURSOR

---

## � วิธีการติดตั้งและรันโปรเจกต์ (Installation Guide)

### สิ่งที่ต้องมีเบื้องต้น
- [Node.js](https://nodejs.org/en/) (เวอร์ชัน 16 หรือสูงกว่า)
- Oracle Database 21c XE สามาถเชื่อมต่อแบบ Local หรือผ่านโปรแกรมจำลอง LAN (เช่น Hamachi)

### ขั้นตอนที่ 1: การติดตั้ง Backend / Frontend
1. **Clone Repository (หรือแตกไฟล์ zip โฟลเดอร์ของโปรเจกต์):**
   ```bash
   git clone <URL_REPO>
   cd DBMSFinal
   ```
2. **ติดตั้ง Required Packages:** เข้าไปที่โฟลเดอร์ `web` แล้วรัน `npm install`
   ```bash
   cd web
   npm install
   ```
   แพ็กเกจหลักที่ใช้คือ `express`, `oracledb`, `express-session`, `cors` 

### ขั้นตอนที่ 2: การตั้งค่าฐานข้อมูล (Database Setup)
หากคุณนำไปรันบนเวอร์เซอร์ใหม่ที่ "ยังไม่มีฐานข้อมูล" คุณจำเป็นต้องสร้าง User ขึ้นมาก่อนเพื่อให้ระบบมีที่เก็บตาราง

1. เปิด SQL Plus หรือ Oracle SQL Developer 
2. ล็อกอินเข้าฐานข้อมูลด้วยบัญชี Admin สูงสุด (เช่น `SYSTEM` หรือ `SYS as SYSDBA`)
3. **สร้าง User สำหรับโปรเจกต์ (เช่น dbms_dev)** โดยรันคำสั่ง SQL ต่อไปนี้:
   ```sql
   ALTER SESSION SET "_ORACLE_SCRIPT"=true; -- (สำหรับ Oracle 12c ขึ้นไป)
   CREATE USER dbms_dev IDENTIFIED BY password_ของคุณ;
   GRANT CONNECT, RESOURCE, DBA TO dbms_dev;
   ```
4. กด Disconnect แล้ว **ล็อกอินเข้าใหม่** ด้วย User ที่เพิ่งสร้าง (`dbms_dev`)
5. นำไฟล์สคริปต์ในโฟลเดอร์ `Table` มารันตามลำดับเพื่อสร้าง Tables / Sequences / และ Stored Procedures
6. นำไฟล์สคริปต์ในโฟลเดอร์ `Data` มารันตามลำดับเพื่อเพิ่มข้อมูลจำลอง (Seed Data)

### ขั้นตอนที่ 3: การเชื่อมต่อ (Configuration)
เปิดไฟล์ `web/db.js` ขึ้นมา และแก้ไขค่า **Connection String** ให้ตรงกับเซิร์ฟเวอร์ฐานข้อมูลของคุณ
```javascript
// ตัวอย่างในไฟล์ web/db.js
const connAttrs = {
    user: 'dbms_dev',
    password: 'password_ของคุณ',
    connectString: 'localhost:1521/XE' // เปลี่ยนให้ตรงกับ IP และ Port ของคุณ (เช่น 25.33.x.x กรณีใช้ Hamachi)
};
```

### ขั้นตอนที่ 4: สตาร์ทโปรเจกต์ (Start Server)
เมื่อตั้งค่าทุกอย่างเสร็จแล้ว ตอนนี้คุณสามารถรันเว็บแอปได้เลย!
1. ตรวจสอบให้แน่ใจว่าอยู่ในโฟลเดอร์ `/web` (ที่มีโฟลเดอร์ public และไฟล์ server.js)
2. รันคำสั่งนี้ใน Command Prompt หรือ Terminal
   ```bash
   node server.js
   ```
3. หากสำเร็จ Terminal จะเด้งข้อความแจ้งว่า:
   `Server is running on port 3000`
   `✅ เชื่อมต่อ Oracle DB สำเร็จ`

### ขั้นตอนที่ 5: เข้าใช้งาน
1. เปิด Web Browser (Google Chrome / Edge)
2. พิมพ์ URL: `http://localhost:3000`
3. ล็อกอินเข้าสู่ระบบด้วย Username ปกติ (ไม่ต้องใช้รหัสผ่าน หรือทดสอบล็อกอินด้วยรหัสมั่วไปก่อนตามการตั้งค่าจำลองปัจจุบัน)
   > *แนะนำให้ใช้พนักงานระดับ Manager (เช่น "กัญญารัตน์", "วิดาภา") เพื่อให้เห็นเมนูครบทุกส่วน*

---

## � Troubleshooting (ปัญหาที่พบบ่อย)

- **`ORA-12170: TNS:Connect timeout occurred`**: 
  เซิร์ฟเวอร์ Node.js ติดต่อกับ Oracle DB ไม่ได้ ให้เช็คว่าเปิด Hamachi เเล้วหรือยัง และ IP ใน `db.js` ถูกต้องหรือไม่ 
- **`DPI-1047: Cannot locate a 64-bit Oracle Client library`**:
  การใช้รันแพ็กเกจ `oracledb` บนเครื่อง Windows คุณอาจจะต้องดาวน์โหลด [Oracle Instant Client](https://www.oracle.com/database/technologies/instant-client/downloads.html) แตกไฟล์ไว้และเพิ่มเข้าไปที่ System Environment Variables (`PATH`) ของ Windows
- **หน้าเว็บดึงข้อมูลมาไม่ครบ**:
  ให้เช็คว่าคุณได้รันสคริปต์ Stored Procedure ครบทั้งหมดหรือไม่ ลองดูในโฟลเดอร์ `Table/Procedures`

---

*ถ้าติดปัญหาตรงไหน สามารถทักมาสอบถาม หรือเปิด Issues ทิ้งไว้ใน Repo ได้เลยครับ ยินดีช่วยเหลือให้รันได้ 100% ครับ!* 🎉
