-- ลบพนักงาน พร้อมเช็ค Referential Integrity ก่อนลบ
CREATE OR REPLACE PROCEDURE sp_delete_employee(
    p_emp_id    IN VARCHAR2,
    p_result    OUT VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    -- เช็คว่ามีประวัติขายไหม
    SELECT COUNT(*) INTO v_count
    FROM Sales_Header
    WHERE TRIM(EMP_ID) = TRIM(p_emp_id);

    IF v_count > 0 THEN
        p_result := 'ERROR: ไม่สามารถลบได้ พนักงานมีประวัติการขาย (' || v_count || ' รายการ)';
        RETURN;
    END IF;

    -- เช็คว่ามีใบสั่งซื้อไหม
    SELECT COUNT(*) INTO v_count
    FROM Purchase_Header
    WHERE TRIM(EMP_ID) = TRIM(p_emp_id);

    IF v_count > 0 THEN
        p_result := 'ERROR: ไม่สามารถลบได้ พนักงานมีใบสั่งซื้ออ้างอิง';
        RETURN;
    END IF;

    DELETE FROM Employees WHERE TRIM(EMP_ID) = TRIM(p_emp_id);
    p_result := 'SUCCESS: ลบพนักงานสำเร็จ';
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
