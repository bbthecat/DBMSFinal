-- =====================================================================
-- Procedure: sp_add_sale_item
-- หน้าที่: นำยาลงตะกร้าขาย (เพิ่มรายละเอียดบิล) พร้อมกับตัดสต็อกและคำนวณเงิน
-- หลักการทำงาน (Logic):
-- 1. ล็อกแถวข้อมูล (Row-level Lock) ด้วย `FOR UPDATE` เพื่อป้องกัน Concurrency (ปัญหาคนซื้อแย่งล็อตเดียวกันพร้อมกัน)
-- 2. เช็คสต็อก: ถ้ายาน้อยกว่าที่ลูกค้าต้องการ จะ Throw Error ทันที
-- 3. คำนวณ (ราคา * จำนวน) - ส่วนลด = ยอดย่อย (Subtotal)
-- 4. บันทึก Transaction 3 ส่วน:
--    4.1 Insert รายการยาลง Sales_Detail
--    4.2 Update หักสต็อก Remaining_Qty ออกจาก Product_Batches
--    4.3 Update บวกยอดเงินทบเข้า Total_Amount ใน Sales_Header
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_add_sale_item(
    p_detail_id     IN VARCHAR2,
    p_sale_id       IN VARCHAR2,
    p_batch_id      IN VARCHAR2,
    p_quantity      IN NUMBER,
    p_unit_price    IN NUMBER,
    p_discount      IN NUMBER,
    p_result        OUT VARCHAR2
) AS
    v_remaining NUMBER;
    v_subtotal  NUMBER;
BEGIN
    -- ขั้นตอนที่ 1: เช็คสต็อกเพียงพอหรือไม่ 
    -- (ใช้ FOR UPDATE เพื่อล็อก Row นี้กัน Transaction อื่นมาดึงข้อมูลไปพร้อมกันจนเกิด Race Condition)
    SELECT Remaining_Qty INTO v_remaining
    FROM Product_Batches
    WHERE TRIM(Batch_ID) = TRIM(p_batch_id)
    FOR UPDATE;

    IF v_remaining < p_quantity THEN
        p_result := 'ERROR: สต็อกไม่เพียงพอ (เหลือ ' || v_remaining || ' ชิ้น)';
        RETURN;
    END IF;

    -- ขั้นตอนที่ 2: คำนวณราคาสุทธิของยาตัวนี้ (Price x Qty - Discount)
    v_subtotal := (p_unit_price * p_quantity) - NVL(p_discount, 0);

    -- ขั้นตอนที่ 3: บันทึกรายการลงตารางลูก (Sales_Detail)
    INSERT INTO Sales_Detail (Detail_ID, Quantity, Subtotal, Unit_Price, Discount, Sale_ID, Batch_ID)
    VALUES (p_detail_id, p_quantity, v_subtotal, p_unit_price, NVL(p_discount, 0), p_sale_id, p_batch_id);

    -- ขั้นตอนที่ 4: ตัดสต็อก (ลดจำนวน Remaining_Qty ในตาราง Product_Batches ตามที่ขายไป)
    UPDATE Product_Batches
    SET Remaining_Qty = Remaining_Qty - p_quantity
    WHERE TRIM(Batch_ID) = TRIM(p_batch_id);

    -- ขั้นตอนที่ 5: ทบยอดเงินกลับไปที่ตารางแม่ (บวก Subtotal ทบเข้าไปที่ Total_Amount ของ Sales_Header)
    UPDATE Sales_Header
    SET Total_Amount = Total_Amount + v_subtotal
    WHERE TRIM(Sale_ID) = TRIM(p_sale_id);

    p_result := 'SUCCESS';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'ERROR: ไม่พบ Batch ID: ' || p_batch_id;
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
