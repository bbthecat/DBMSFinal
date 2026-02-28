-- =====================================================================
-- Procedure: sp_receive_purchase
-- หน้าที่: รับสินค้าเข้าคลังหลังจาก Supplier มาส่งของ (สร้าง Lot อัตโนมัติ)
-- หลักการทำงาน (Logic):
-- 1. ล็อก Header บิลสั่งซื้อไว้ก่อนและเช็คว่ามีการกดรับซ้ำหรือไม่
-- 2. วนลูป (FOR rec IN Cursor) อ่านรายการยาทุกตัวในบิลสั่งซื้อนี้ว่ามีสั่งอะไรมาบ้าง
-- 3. ในแต่ละรอบลูป: นำยาตัวนั้นไปสร้างรหัส Batch_ID ใหม่ตามเวลาปัจจุบัน (YYMMDDHH24MI + Running No.)
-- 4. บันทึกลงตาราง Product_Batches (เป็นการเสกยาเข้าสต็อกร้าน)
-- 5. หากทุกยารับสำเร็จ จะเปลี่ยนสถานะบิลแม่เป็น 'รับสินค้าแล้ว' (จบกระบวนการ)
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_receive_purchase(
    p_purchase_id   IN VARCHAR2,
    p_result        OUT VARCHAR2
) AS
    v_status    VARCHAR2(100);
    v_batch_id  VARCHAR2(13);
    v_counter   NUMBER := 0;
BEGIN
    -- ขั้นตอนที่ 1: ดึงสถานะปัจจุบันของบิล เพื่อเช็คการรับของซ้ำซ้อน
    -- ล็อกแถวนี้ด้วย FOR UPDATE ป้องกัน Manager 2 คนกดปุ่มรับของพร้อมกัน
    SELECT Status INTO v_status
    FROM Purchase_Header
    WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id)
    FOR UPDATE;

    IF v_status = 'รับสินค้าแล้ว' THEN
        p_result := 'ERROR: ใบสั่งซื้อนี้รับสินค้าไปแล้ว';
        RETURN;
    END IF;

    -- ขั้นตอนที่ 2: ใช้ For-Loop Cursor กวาดรายการยาทุกตัวใน Purchase_Detail ที่ผูกกับบิลรหัสนี้
    FOR rec IN (
        SELECT P_Detail_ID, Product_ID, Order_Qty, Cost_Price
        FROM Purchase_Detail
        WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id)
    ) LOOP
        v_counter := v_counter + 1;
        
        -- ขั้นตอนที่ 3: จำลองรูปแบบรหัสล็อต (Data Generation Logic)
        -- รหัส Batch จะใช้ฟอร์แมต: BAT + ปีเดือนวันชั่วโมงนาที + เลขรันนิ่ง (เช่น BAT250301143001)
        v_batch_id := 'BAT' || TO_CHAR(SYSDATE, 'YYMMDDHH24MI') || LPAD(v_counter, 2, '0');
        v_batch_id := SUBSTR(v_batch_id, 1, 13);

        -- ขั้นตอนที่ 4: เติมยาเข้าคลัง (เสกของเข้า Product_Batches)
        -- รับยาเข้ามาเท่าไหร่ (Order_Qty) ก็ให้มีของคงเหลือพร้อมขายเท่านั้น (Remaining_Qty = Order_Qty)
        INSERT INTO Product_Batches (
            Batch_ID, MFG_date, EXP_date, Cost_Price,
            Lot_Number, Received_Qty, Remaining_Qty,
            Import_Date, Product_ID, Purchase_ID
        ) VALUES (
            v_batch_id,
            SYSDATE,                                -- วันผลิต (สมมติให้เป็นวันนี้)
            ADD_MONTHS(SYSDATE, 24),                -- วันหมดอายุ (บวกไป 24 เดือน หรือ 2 ปี)
            rec.Cost_Price,                         -- ต้นทุนส่งพาสมาจากใบสั่งซื้อ
            'LOT' || TO_CHAR(SYSDATE, 'YYMMDD'),    -- สร้างเลข Lot สมมติ
            rec.Order_Qty,                          -- ยอดรับเข้า
            rec.Order_Qty,                          -- ยอดสะสมพร้อมขาย
            SYSDATE,                                -- วันนำเข้า
            rec.Product_ID,
            p_purchase_id
        );
    END LOOP;

    -- ขั้นตอนที่ 5: อัพเดทตารางแม่ให้สถานะเปลี่ยนไป เพื่อไม่ให้มารับซ้ำอีกครั้งในอนาคต
    UPDATE Purchase_Header
    SET Status = 'รับสินค้าแล้ว'
    WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id);

    p_result := 'SUCCESS: สร้าง ' || v_counter || ' Batch สำเร็จ';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'ERROR: ไม่พบใบสั่งซื้อ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
