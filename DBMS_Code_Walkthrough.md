# 🔬 อธิบาย Code จริงทีละบรรทัด

> เปิดคู่กับไฟล์ต้นฉบับ อ่านแล้วจะเข้าใจว่าแต่ละบรรทัดทำอะไร

---

## 📁 1. `sp_create_sale.sql` — สร้างบิลขาย

```sql
CREATE OR REPLACE PROCEDURE sp_create_sale(
    p_emp_id    IN VARCHAR2,   -- รับ: รหัสพนักงานที่ขาย
    p_sale_id   OUT VARCHAR2,  -- ส่งออก: รหัสบิลที่สร้าง
    p_result    OUT VARCHAR2   -- ส่งออก: "SUCCESS" หรือ "ERROR: ..."
) AS
```
> `IN` = รับค่าเข้ามา | `OUT` = ส่งค่ากลับไป | `VARCHAR2` = ข้อความ

```sql
BEGIN
    p_sale_id := 'SAL' || LPAD(seq_sale.NEXTVAL, 10, '0');
```
> - `seq_sale.NEXTVAL` → ขอเลขคิวถัดไป เช่น ได้ `101`
> - `LPAD(..., 10, '0')` → เติม 0 หน้าให้ครบ 10 หลัก → `0000000101`
> - `'SAL' ||` → ต่อหน้า → ได้ `SAL0000000101`
> - `:=` คือเครื่องหมาย "กำหนดค่า" ใน PL/SQL (ไม่ใช่ `=`)

```sql
    INSERT INTO Sales_Header (Sale_ID, Sale_date, Total_Amount, EMP_ID)
    VALUES (p_sale_id, SYSDATE, 0, p_emp_id);
```
> - สร้างแถวใหม่ในตาราง `Sales_Header`
> - `SYSDATE` = วันเวลาของ Server ณ ตอนนี้
> - `Total_Amount = 0` → ตั้งเป็น 0 ก่อน จะบวกเพิ่มทีหลังใน `sp_add_sale_item`

```sql
    p_result := 'SUCCESS';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสบิลซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;  -- SQLERRM = ข้อความ Error จาก Oracle
END;
```
> ถ้าเกิดข้อผิดพลาดกลางทาง → กระโดดมาที่ `EXCEPTION` ทันที ไม่ทำต่อ

---

## 📁 2. `sp_add_sale_item.sql` — ขายยาและตัดสต็อก

นี่คือ Procedure ที่ซับซ้อนและสำคัญที่สุด

```sql
CREATE OR REPLACE PROCEDURE sp_add_sale_item(
    p_sale_id       IN VARCHAR2,   -- รหัสบิลที่สร้างแล้ว
    p_batch_id      IN VARCHAR2,   -- รหัสล็อตยาที่จะขาย
    p_quantity      IN NUMBER,     -- จำนวนที่จะขาย
    p_unit_price    IN NUMBER,     -- ราคาต่อชิ้น
    p_discount      IN NUMBER,     -- ส่วนลด (ถ้ามี)
    p_detail_id     OUT VARCHAR2,  -- รหัส ID ของรายการนี้ที่สร้างขึ้น
    p_result        OUT VARCHAR2   -- ผลลัพธ์
) AS
    v_remaining NUMBER;   -- ตัวแปรเก็บสต็อกที่เหลือ
    v_subtotal  NUMBER;   -- ตัวแปรเก็บยอดเงินรายการนี้
```

```sql
BEGIN
    -- สร้าง ID สำหรับรายการนี้
    p_detail_id := 'SDT' || LPAD(seq_sale_detail.NEXTVAL, 10, '0');
```
> `SDT` + เลขคิว → เช่น `SDT0000000101`

```sql
    -- ⭐ บรรทัดสำคัญมาก: ล็อกแถวก่อนดู
    SELECT Remaining_Qty INTO v_remaining
    FROM Product_Batches
    WHERE TRIM(Batch_ID) = TRIM(p_batch_id)
    FOR UPDATE;
```
> - `SELECT ... INTO v_remaining` → ดึงสต็อกมาเก็บในตัวแปร `v_remaining`
> - `TRIM(Batch_ID)` → ตัด space ออก เพราะ CHAR type เก็บ space ต่อท้าย
> - **`FOR UPDATE`** → 🔒 ล็อกแถวนี้ทันที! Transaction อื่นต้องรอจนกว่าจะ COMMIT/ROLLBACK

```sql
    IF v_remaining < p_quantity THEN
        p_result := 'ERROR: สต็อกไม่เพียงพอ (เหลือ ' || v_remaining || ' ชิ้น)';
        RETURN;  -- หยุดทำงาน ออกจาก Procedure ทันที
    END IF;
```
> เช็คว่าสต็อกพอไหม → ถ้าไม่พอ ส่ง Error กลับแล้วหยุดเลย ไม่ทำต่อ

```sql
    -- คำนวณยอดเงิน
    v_subtotal := (p_unit_price * p_quantity) - NVL(p_discount, 0);
```
> - `NVL(p_discount, 0)` → ถ้า discount เป็น NULL ให้ถือว่าเป็น 0 (กัน error)
> - ยอดเงิน = ราคา × จำนวน - ส่วนลด

```sql
    -- บันทึกรายการในตารางลูก
    INSERT INTO Sales_Detail (Detail_ID, Quantity, Subtotal, Unit_Price, Discount, Sale_ID, Batch_ID)
    VALUES (p_detail_id, p_quantity, v_subtotal, p_unit_price, NVL(p_discount, 0), p_sale_id, p_batch_id);
```
> สร้าง 1 แถวในตาราง `Sales_Detail` = 1 รายการยาในบิล

```sql
    -- หักสต็อก
    UPDATE Product_Batches
    SET Remaining_Qty = Remaining_Qty - p_quantity
    WHERE TRIM(Batch_ID) = TRIM(p_batch_id);
```
> ลด `Remaining_Qty` โดยตรงในตาราง = ตัดของออกจากชั้นวาง

```sql
    -- ทบยอดเงินในบิล
    UPDATE Sales_Header
    SET Total_Amount = Total_Amount + v_subtotal
    WHERE TRIM(Sale_ID) = TRIM(p_sale_id);

    p_result := 'SUCCESS';
```
> บวกยอดเงินรายการนี้เข้าไปในบิล (Total_Amount สะสมไปเรื่อยๆ)

---

## 📁 3. `sp_receive_purchase.sql` — รับสินค้าเข้าคลัง

```sql
CREATE OR REPLACE PROCEDURE sp_receive_purchase(
    p_purchase_id   IN VARCHAR2,   -- รหัสใบสั่งซื้อที่จะรับ
    p_result        OUT VARCHAR2
) AS
    v_status    VARCHAR2(100);  -- เก็บสถานะปัจจุบันของใบสั่งซื้อ
    v_batch_id  VARCHAR2(13);   -- เก็บรหัส Batch ที่กำลังสร้าง
    v_counter   NUMBER := 0;    -- ตัวนับยาแต่ละตัว (ใช้สร้าง ID ไม่ซ้ำ)
```

```sql
    -- เช็คสถานะก่อน + ล็อกแถว
    SELECT Status INTO v_status
    FROM Purchase_Header
    WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id)
    FOR UPDATE;
```
> ดึงสถานะมาเก็บ + ล็อกไว้ ป้องกัน Manager 2 คนกดรับพร้อมกัน

```sql
    IF v_status = 'รับสินค้าแล้ว' THEN
        p_result := 'ERROR: ใบสั่งซื้อนี้รับสินค้าไปแล้ว';
        RETURN;
    END IF;
```
> State Guard: ถ้ารับไปแล้ว → ห้ามรับซ้ำ → ออกเลย

```sql
    -- วนลูปทุกรายการยาในใบสั่งซื้อ
    FOR rec IN (
        SELECT P_Detail_ID, Product_ID, Order_Qty, Cost_Price
        FROM Purchase_Detail
        WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id)
    ) LOOP
```
> - **Implicit Cursor FOR LOOP** = Oracle เปิด-อ่าน-ปิด Cursor อัตโนมัติ
> - `rec` = ตัวแปรที่เก็บข้อมูลของแถวปัจจุบัน
> - ทุกรอบ = ยา 1 ตัวในใบสั่งซื้อ

```sql
        v_counter := v_counter + 1;
        -- สร้าง Batch ID: B + ปีเดือนวันชั่วโมงนาที + เลขลำดับ
        v_batch_id := SUBSTR(
            'B' || TO_CHAR(SYSDATE, 'YYMMDDHH24MI') || LPAD(v_counter, 2, '0'),
            1, 13
        );
```
> - `TO_CHAR(SYSDATE,'YYMMDDHH24MI')` → เช่น `2603021430` (26 มี.ค. 02 14:30)
> - `LPAD(v_counter,2,'0')` → `01`, `02`, `03`...
> - รวมกัน: `B260302143001` (13 ตัวพอดี)
> - `SUBSTR(...,1,13)` → ตัดให้ได้แค่ 13 ตัวอักษร (ตาม CHAR(13))

```sql
        INSERT INTO Product_Batches (
            Batch_ID, MFG_date, EXP_date, Cost_Price,
            Lot_Number, Received_Qty, Remaining_Qty,
            Import_Date, Product_ID, Purchase_ID
        ) VALUES (
            v_batch_id,
            SYSDATE,                      -- วันผลิต = วันที่รับสินค้า
            ADD_MONTHS(SYSDATE, 24),      -- หมดอายุ = วันนี้ + 24 เดือน
            rec.Cost_Price,               -- ราคาทุนจากใบสั่งซื้อ
            'LOT' || TO_CHAR(SYSDATE,'YYMMDD'),
            rec.Order_Qty,                -- รับมากี่ชิ้น
            rec.Order_Qty,                -- พร้อมขายมากี่ชิ้น (= รับทั้งหมด ตอนเริ่ม)
            SYSDATE, rec.Product_ID, p_purchase_id
        );
    END LOOP;
```
> - `ADD_MONTHS(SYSDATE, 24)` = วันหมดอายุ 2 ปีนับจากวันนี้
> - `rec.Order_Qty` → ดึงจากตัวแปร Cursor ที่ Oracle กำลังชี้อยู่

```sql
    -- เปลี่ยนสถานะบิลเป็น "รับแล้ว"
    UPDATE Purchase_Header
    SET Status = 'รับสินค้าแล้ว'
    WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id);

    p_result := 'SUCCESS: สร้าง ' || v_counter || ' Batch สำเร็จ';
```
> หลัง Loop จบ → เปลี่ยนสถานะ → บอก Node.js ว่าสร้าง N ล็อตสำเร็จ

---

## 📁 4. `trg_product_audit.sql` — บันทึกประวัติเปลี่ยนแปลงสินค้า

```sql
CREATE OR REPLACE TRIGGER trg_product_audit
AFTER INSERT OR UPDATE OR DELETE ON Product  -- ทำงานหลัง DML บนตาราง Product
FOR EACH ROW                                  -- ทำงานทุกแถวที่ถูกแก้ไข
```
> **AFTER** = ทำหลัง DML สำเร็จ (ไม่ใช่ก่อน)
> **FOR EACH ROW** = ถ้า UPDATE 10 แถว → Trigger ทำงาน 10 ครั้ง

```sql
BEGIN
    IF INSERTING THEN  -- เกิดจาก INSERT
        INSERT INTO Product_Audit_Log (Action_Type, Product_ID, Product_Name, New_Price, Details)
        VALUES ('INSERT', :NEW.Product_ID, :NEW.Product_Name, :NEW.Unit_Price,
                'เพิ่มสินค้าใหม่: ' || :NEW.Product_Name);
```
> - `INSERTING` = predicate เช็คว่า Trigger ถูกเรียกจาก INSERT
> - `:NEW.Product_ID` = ค่า **ใหม่** ของแถวที่กำลัง INSERT

```sql
    ELSIF UPDATING THEN  -- เกิดจาก UPDATE
        INSERT INTO Product_Audit_Log (..., Old_Price, New_Price, ...)
        VALUES ('UPDATE', :NEW.Product_ID, :NEW.Product_Name,
                :OLD.Unit_Price,   -- ราคาก่อนแก้
                :NEW.Unit_Price,   -- ราคาหลังแก้
                'แก้ไขสินค้า: ' || :OLD.Product_Name || ' → ' || :NEW.Product_Name);
```
> - `:OLD` = ค่า **เดิม** ก่อน UPDATE
> - `:NEW` = ค่า **ใหม่** หลัง UPDATE
> - บันทึกทั้งก่อนและหลัง → ตรวจสอบย้อนหลังได้

```sql
    ELSIF DELETING THEN  -- เกิดจาก DELETE
        INSERT INTO Product_Audit_Log (..., Old_Price, ...)
        VALUES ('DELETE', :OLD.Product_ID, :OLD.Product_Name, :OLD.Unit_Price,
                'ลบสินค้า: ' || :OLD.Product_Name);
    END IF;
END;
```
> ตอน DELETE ไม่มี `:NEW` (ของถูกลบแล้ว) → ใช้แต่ `:OLD`

---

## 📁 5. `trg_low_stock_alert.sql` — แจ้งเตือนสต็อกต่ำ (Compound Trigger)

```sql
CREATE OR REPLACE TRIGGER trg_low_stock_alert
FOR UPDATE OF Remaining_Qty ON Product_Batches  -- เฉพาะตอน UPDATE คอลัมน์นี้
COMPOUND TRIGGER  -- Trigger พิเศษที่มีหลาย Phase
```

```sql
    -- ประกาศตัวแปรชนิด Array (Collection) เก็บ Product_ID ที่ถูก UPDATE
    TYPE t_product_ids IS TABLE OF Product_Batches.Product_ID%TYPE;
    g_product_ids t_product_ids := t_product_ids();  -- สร้าง Array ว่าง
```
> `%TYPE` = ยืม Type มาจาก Column `Product_ID` (ไม่ต้องระบุตรงๆ)

```sql
    -- Phase 1: ทำงานทุกแถวที่ถูก UPDATE
    AFTER EACH ROW IS
    BEGIN
        g_product_ids.EXTEND;                               -- ขยาย Array +1
        g_product_ids(g_product_ids.COUNT) := :NEW.Product_ID;  -- เก็บ ID ลง Array
    END AFTER EACH ROW;
```
> **ทำไมแค่เก็บ ID ไม่ทำอะไรมากกว่านี้?**
> เพราะในตอนนี้ตาราง `Product_Batches` กำลัง UPDATE อยู่ (Mutating) → ห้าม SELECT รวมกลับ!

```sql
    -- Phase 2: ทำงาน 1 ครั้งหลัง UPDATE Statement จบทั้งหมด
    AFTER STATEMENT IS
        v_total_stock   NUMBER;
        v_reorder_point NUMBER;
        v_product_name  VARCHAR2(100);
        v_exists        NUMBER;
    BEGIN
        -- วนลูป Array ที่เก็บไว้
        FOR i IN 1..g_product_ids.COUNT LOOP
```
> **ตอนนี้ปลอดภัยแล้ว** → Statement จบแล้ว ตาราง Mutate เสร็จ → SELECT SUM() ได้

```sql
            -- รวมสต็อกทุก Batch ของสินค้านี้
            SELECT NVL(SUM(Remaining_Qty), 0)
            INTO v_total_stock
            FROM Product_Batches
            WHERE Product_ID = g_product_ids(i);

            -- ดึง Reorder Point ของสินค้า
            SELECT Reorder_Point, Product_Name
            INTO v_reorder_point, v_product_name
            FROM Product
            WHERE Product_ID = g_product_ids(i);
```

```sql
            -- เช็ค: สต็อกรวมน้อยกว่าจุดสั่งซื้อไหม?
            IF v_total_stock < v_reorder_point THEN
                -- เช็คว่าวันนี้แจ้งเตือนสินค้านี้ไปแล้วหรือยัง (ไม่แจ้งซ้ำ)
                SELECT COUNT(*) INTO v_exists
                FROM Stock_Alert_Log
                WHERE Product_ID = g_product_ids(i)
                  AND TRUNC(Alert_Date) = TRUNC(SYSDATE);  -- TRUNC ตัดเวลา เหลือแค่วัน
```
> - `TRUNC(Alert_Date) = TRUNC(SYSDATE)` → เช็คว่าเป็นวันเดียวกัน (ไม่สนเวลา)

```sql
                IF v_exists = 0 THEN  -- ถ้ายังไม่มี Alert วันนี้
                    INSERT INTO Stock_Alert_Log (Product_ID, Product_Name, Current_Stock, Reorder_Point)
                    VALUES (g_product_ids(i), v_product_name, v_total_stock, v_reorder_point);
                END IF;
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END trg_low_stock_alert;
```

---

## 📁 6. `app.js` (Frontend) — การทำงานของ JavaScript

### 6.1 ฟังก์ชัน `api()` — ตัวกลางคุยกับ Server

```js
async function api(url, options = {}) {
    try {
        const res = await fetch(url, {        // เรียก HTTP Request
            headers: { 'Content-Type': 'application/json' },
            credentials: 'same-origin',       // ส่ง Cookie (Session) ไปด้วย
            ...options                        // รวม options ที่ส่งมา (method, body)
        });
        const data = await res.json();        // แปลง Response เป็น Object
        if (!res.ok) throw new Error(data.error || 'เกิดข้อผิดพลาด');
        return data;
    } catch (err) {
        throw err;                            // โยน Error ต่อให้ผู้เรียกจัดการ
    }
}
```
> - `async/await` = รอให้ Request เสร็จก่อน (ไม่บล็อก browser)
> - `fetch()` = Web API สำหรับเรียก HTTP (ทดแทน XMLHttpRequest)
> - ใช้แบบนี้: `const data = await api('/api/products')` → ได้ Array สินค้ากลับมา

### 6.2 ฟังก์ชัน `navigateTo()` — Router แบบ SPA

```js
function navigateTo(page) {
    currentPage = page;
    document.getElementById('page-title').textContent = pageTitles[page] || page;

    // เปลี่ยน Active Menu
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    const navItem = document.querySelector(`.nav-item[data-page="${page}"]`);
    if (navItem) navItem.classList.add('active');

    // แสดง Loading spinner ก่อน
    const content = document.getElementById('content-area');
    content.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    // เรียกฟังก์ชันโหลดหน้า
    const pages = {
        dashboard: loadDashboard, pos: loadPOS, products: loadProducts, ...
    };
    if (pages[page]) pages[page]();  // เรียก loadDashboard() / loadPOS() ฯลฯ
}
```
> - **SPA** (Single Page Application) = ไม่รีเฟรชหน้า แค่สลับ HTML ใน `content-area`
> - แทนที่จะไปหน้าใหม่ → แค่เปลี่ยน innerHTML ของ `<div id="content-area">`

### 6.3 ฟังก์ชัน `addToCart()` — เพิ่มยาลงตะกร้า (FEFO Logic)

```js
function addToCart(batches) {
    // FEFO = First Expired, First Out
    // เลือก Batch ที่มีของเหลือ (ล็อตแรกใน Array คือหมดอายุก่อนสุด)
    const batch = batches.find(b => b.REMAINING_QTY > 0);
    if (!batch) { showToast('สินค้าหมด', 'warning'); return; }

    // เช็คว่ามีในตะกร้าแล้วไหม
    const existing = cart.find(c => c.BATCH_ID === batch.BATCH_ID);
    if (existing) {
        // มีแล้ว → แค่เพิ่มจำนวน
        if (existing.Quantity >= batch.REMAINING_QTY) {
            showToast('สินค้าในสต็อกไม่พอ', 'warning');
            return;
        }
        existing.Quantity++;
    } else {
        // ยังไม่มี → เพิ่มใหม่
        cart.push({
            BATCH_ID: batch.BATCH_ID,
            PRODUCT_NAME: batch.PRODUCT_NAME,
            Unit_Price: batch.UNIT_PRICE,
            Quantity: 1,
            Discount: 0,
            maxQty: batch.REMAINING_QTY  // จำกัดไว้ ห้ามกดเกินสต็อก
        });
    }
    renderCartItems();  // วาด UI ตะกร้าใหม่
}
```
> `batches.find()` = หาตัวแรกที่ตรงเงื่อนไข (REMAINING_QTY > 0) → ล็อตที่หมดอายุก่อน

### 6.4 ฟังก์ชัน `checkout()` — ชำระเงิน

```js
async function checkout() {
    if (cart.length === 0) return;

    // แปลงตะกร้าให้เป็น Format ที่ Server รับได้
    const items = cart.map(item => ({
        Batch_ID: item.BATCH_ID,
        Quantity: item.Quantity,
        Unit_Price: item.Unit_Price,
        Discount: item.Discount
    }));

    try {
        // ส่งไป POST /api/sales (sales.js Route จะรับต่อ)
        await api('/api/sales', {
            method: 'POST',
            body: JSON.stringify({ items })  // แปลงเป็น JSON String ก่อนส่ง
        });
        showToast('บันทึกการขายสำเร็จ!', 'success');
        cart = [];      // ล้างตะกร้า
        loadPOS();      // โหลดหน้า POS ใหม่ (สต็อกจะอัพเดทแล้ว)
    } catch (err) {
        showToast(err.message, 'error');  // แสดง Error ถ้า sp_add_sale_item ส่งกลับมา
    }
}
```

### 6.5 ฟังก์ชัน `filterPOSProducts()` — ค้นหายาแบบ Real-time

```js
function filterPOSProducts() {
    const query = document.getElementById('pos-search').value.toLowerCase();
    const cards = document.querySelectorAll('.pos-product-card');

    cards.forEach(card => {
        const name = card.querySelector('.prod-name').textContent.toLowerCase();
        const generic = card.querySelector('.prod-generic').textContent.toLowerCase();
        const cat = card.dataset.category || '';  // อ่านจาก data-category attribute

        const matchSearch = !query || name.includes(query) || generic.includes(query);
        const matchCat = posCategory === 'all' || cat === posCategory;

        // ซ่อน/แสดง Card แทนการลบ-สร้างใหม่ (เร็วกว่า)
        card.style.display = (matchSearch && matchCat) ? '' : 'none';
    });
}
```
> - ค้นหา **ทั้งชื่อยาและชื่อสามัญ** พร้อมกัน
> - ไม่ต้องเรียก API ใหม่ → ค้นหาจาก DOM ที่มีอยู่แล้ว (เร็วมาก)

---

## 📁 7. `sales.js` (Route) — รับคำสั่ง POST จาก Frontend

```js
router.post('/', async (req, res) => {
    let conn;
    try {
        const { items } = req.body;             // รับ Array ของยาจาก Frontend
        const EMP_ID = req.session.user.EMP_ID; // รหัสพนักงานจาก Session (Login)

        // ขอ Connection จาก Pool (ไม่ Auto-commit)
        conn = await db.getConnection();

        // ขั้น 1: สร้างบิล
        const headerResult = await conn.execute(
            `BEGIN sp_create_sale(:p_emp_id, :p_sale_id, :p_result); END;`,
            {
                p_emp_id: EMP_ID,
                p_sale_id: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 20 },
                p_result:  { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 }
            }
        );
```
> - `BEGIN ... END;` = วิธีเรียก Stored Procedure ใน Oracle
> - `BIND_OUT` = บอกว่า Parameter นี้เป็น OUT → Node.js จะรอรับค่ากลับมา

```js
        if (!headerResult.outBinds.p_result.startsWith('SUCCESS')) {
            throw new Error(headerResult.outBinds.p_result);  // โยน Error ถ้าไม่ SUCCESS
        }

        const saleId = headerResult.outBinds.p_sale_id;  // รหัสบิลที่ได้มา เช่น SAL0000000101

        // ขั้น 2: วนลูปเพิ่มยาทุกตัว
        for (const item of items) {
            const itemResult = await conn.execute(
                `BEGIN sp_add_sale_item(:p_sale_id, :p_batch_id, :p_quantity,
                                       :p_unit_price, :p_discount, :p_detail_id, :p_result); END;`,
                { /* binds */ }
            );

            if (!itemResult.outBinds.p_result.startsWith('SUCCESS')) {
                throw new Error(itemResult.outBinds.p_result);  // สต็อกหมด → throw → ROLLBACK
            }
        }

        // ขั้น 3: ทุกอย่างสำเร็จ → COMMIT
        await conn.commit();
        res.status(201).json({ message: 'บันทึกการขายสำเร็จ', Sale_ID: saleId });

    } catch (err) {
        // ขั้น 4 (กรณีพัง): ROLLBACK ทุกอย่างกลับ
        if (conn) try { await conn.rollback(); } catch (e) { }
        res.status(500).json({ error: err.message || 'บันทึกการขายไม่ได้' });

    } finally {
        // ขั้น 5: คืน Connection กลับ Pool เสมอ (ไม่ว่าจะสำเร็จหรือพัง)
        if (conn) try { await conn.close(); } catch (e) { }
    }
});
```

---

## 🗺️ สรุปการไหลของ Code ตอนกดขาย

```
👆 ผู้ใช้กดปุ่ม "ชำระเงิน"
   ↓ app.js: checkout()
   ↓ fetch POST /api/sales  {items: [...]}
   ↓ sales.js: router.post('/')
   ↓ db.getConnection()  ← หยิบ Connection จาก Pool
   ↓ sp_create_sale()    ← สร้างบิล (SAL...)
   ↓ FOR LOOP ทุก item:
       ↓ sp_add_sale_item()
           ↓ SELECT FOR UPDATE  ← ล็อกสต็อก
           ↓ IF สต็อกพอ: INSERT + UPDATE + UPDATE
           ↓ trg_low_stock_alert ← ทำงานอัตโนมัติ!
   ↓ conn.commit()   ← บันทึกถาวร
   ↓ conn.close()    ← คืน Connection
   ↓ res.json(201)   ← ตอบ Frontend
   ↓ showToast('สำเร็จ') + loadPOS()
```

---

## 🔑 คำสำคัญที่ต้องจำ

| Code | ภาษาง่ายๆ |
|------|-----------|
| `:=` | เครื่องหมาย "เท่ากับ" ใน PL/SQL (SQL ใช้ `=`) |
| `INTO v_var` | เก็บผลลัพธ์ลงตัวแปร |
| `FOR UPDATE` | ล็อกแถวนี้ไว้ก่อน |
| `:OLD` / `:NEW` | ค่าก่อน/หลังใน Trigger |
| `EXTEND` | ขยาย Array ให้รับค่าเพิ่มได้ |
| `NEXTVAL` | ขอเลขคิวถัดไปจาก Sequence |
| `BIND_OUT` | บอก Node.js ว่ารอรับค่ากลับ |
| `await` | รอให้ทำงานเสร็จก่อน (Async) |
| `...options` | Spread operator = กระจาย Object |
| `throw` | โยน Error ให้ `catch` จัดการต่อ |
