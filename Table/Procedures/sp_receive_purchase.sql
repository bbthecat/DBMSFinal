-- =====================================================================
-- Procedure: sp_receive_purchase
-- หน้าที่: รับสินค้าเข้าคลังทีละ 1 Item (Product_Detail รายการเดียว)
--          โดย Backend จะวนลูปเรียก SP นี้ทีละ item พร้อมส่งข้อมูล Lot จริง
-- หลักการทำงาน (Logic):
-- 1. ตรวจสอบสถานะบิลก่อนว่ายังไม่ได้รับ
-- 2. ดึงข้อมูลยาจาก Purchase_Detail ตาม p_detail_id ที่ส่งมา
-- 3. สร้าง Batch_ID ใหม่แบบ Unique
-- 4. INSERT เข้า Product_Batches ด้วย Lot/MFG/EXP ที่รับมาจาก Backend
-- 5. อัพเดทสถานะบิลแม่ (Backend จะเรียกครั้งสุดท้ายหลัง loop จบ)
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_receive_purchase(
    p_purchase_id   IN VARCHAR2,
    p_detail_id     IN VARCHAR2,      -- รหัสรายการสินค้าใน Purchase_Detail
    p_lot_number    IN VARCHAR2,      -- เลข Lot จากกล่องยาจริง
    p_mfg_date      IN DATE,          -- วันผลิตจริง
    p_exp_date      IN DATE,          -- วันหมดอายุจริง
    p_counter       IN NUMBER,        -- ตัวเลข running สำหรับสร้าง Batch_ID
    p_update_status IN VARCHAR2,      -- 'Y' = อัพเดทสถานะบิลเป็น รับสินค้าแล้ว
    p_result        OUT VARCHAR2
) AS
    v_status        VARCHAR2(100);
    v_batch_id      VARCHAR2(13);
    v_product_id    VARCHAR2(13);
    v_order_qty     NUMBER;
    v_cost_price    NUMBER;
BEGIN
    -- ขั้นตอนที่ 1: ตรวจสอบสถานะบิล (ล็อกแถวป้องกัน race condition)
    SELECT Status INTO v_status
    FROM Purchase_Header
    WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id)
    FOR UPDATE;

    IF v_status = 'รับสินค้าแล้ว' THEN
        p_result := 'ERROR: ใบสั่งซื้อนี้รับสินค้าไปแล้ว';
        RETURN;
    END IF;

    -- ขั้นตอนที่ 2: ดึงข้อมูลยาใน Purchase_Detail ตาม Detail_ID
    SELECT Product_ID, Order_Qty, Cost_Price
    INTO v_product_id, v_order_qty, v_cost_price
    FROM Purchase_Detail
    WHERE TRIM(P_Detail_ID) = TRIM(p_detail_id)
      AND TRIM(Purchase_ID)  = TRIM(p_purchase_id);

    -- ขั้นตอนที่ 3: สร้างรหัส Batch_ID แบบ Unique
    -- รูปแบบ: B + YYMMDDHH24MI (10 chars) + 2 chars running = 13 chars
    v_batch_id := SUBSTR('B' || TO_CHAR(SYSDATE, 'YYMMDDHH24MI') || LPAD(p_counter, 2, '0'), 1, 13);

    -- ขั้นตอนที่ 4: เติมยาเข้าคลัง ด้วยข้อมูล Lot/MFG/EXP จากของจริง
    INSERT INTO Product_Batches (
        Batch_ID, MFG_date, EXP_date, Cost_Price,
        Lot_Number, Received_Qty, Remaining_Qty,
        Import_Date, Product_ID, Purchase_ID
    ) VALUES (
        v_batch_id,
        p_mfg_date,                             -- วันผลิตจากกล่องยาจริง
        p_exp_date,                             -- วันหมดอายุจากกล่องยาจริง
        v_cost_price,                           -- ต้นทุนจากใบสั่งซื้อ
        SUBSTR(p_lot_number, 1, 10),            -- เลข Lot จริง (จำกัด 10 chars)
        v_order_qty,                            -- ยอดรับเข้า
        v_order_qty,                            -- ยอดคงเหลือพร้อมขาย
        CURRENT_TIMESTAMP,                       -- วันนำเข้าระบบ (เวลาไทย)
        v_product_id,
        TRIM(p_purchase_id)
    );

    -- ขั้นตอนที่ 5: อัพเดทสถานะบิลแม่ (เฉพาะ item สุดท้าย หรือเมื่อ Backend บอก)
    IF UPPER(p_update_status) = 'Y' THEN
        UPDATE Purchase_Header
        SET Status = 'รับสินค้าแล้ว'
        WHERE TRIM(Purchase_ID) = TRIM(p_purchase_id);
    END IF;

    p_result := 'SUCCESS: สร้าง Batch ' || v_batch_id || ' สำเร็จ';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'ERROR: ไม่พบรายการสินค้าใน Purchase_Detail';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
