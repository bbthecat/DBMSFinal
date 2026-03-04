-- =====================================================================
-- Procedure: sp_create_sale
-- หน้าที่: สร้างหัวบิลขายใหม่ (Sales_Header) ลงในระบบเมื่อมีการชำระเงิน
-- คำอธิบาย: ทำการบันทึกข้อมูลรหัสบิล, วันที่เวลาขายปัจจุบัน (SYSDATE),
--         ยอดรวมเริ่มต้น (0) และรหัสพนักงานที่ทำการทำรายการ
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_create_sale(
    p_emp_id    IN VARCHAR2,
    p_sale_id   OUT VARCHAR2,
    p_result    OUT VARCHAR2
) AS
BEGIN
    -- สร้างรหัสบิลใหม่ (เช่น SAL0000000101)
    p_sale_id := 'SAL' || LPAD(seq_sale.NEXTVAL, 10, '0');

    -- Insert ข้อมูลบิลขาย โดยเซ็ตยอดรวมเป็น 0 ไปก่อน 
    -- (ยอดรวมจริงจะถูกอัปเดตผ่าน Trigger/Procedure ย่อยตอนเพิ่มรายการยา)
    INSERT INTO Sales_Header (Sale_ID, Sale_date, Total_Amount, EMP_ID)
    VALUES (p_sale_id, CURRENT_TIMESTAMP, 0, p_emp_id);

    p_result := 'SUCCESS'; -- ส่งผลลัพธ์ว่าสำเร็จ
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสบิลซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
