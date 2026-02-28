-- เพิ่มหรือแก้ไขพนักงาน (p_action = 'INSERT' หรือ 'UPDATE')
CREATE OR REPLACE PROCEDURE sp_upsert_employee(
    p_emp_id        IN VARCHAR2,
    p_username      IN VARCHAR2,
    p_password      IN VARCHAR2,
    p_position      IN VARCHAR2,
    p_first_name    IN VARCHAR2,
    p_last_name     IN VARCHAR2,
    p_action        IN VARCHAR2,
    p_result        OUT VARCHAR2
) AS
BEGIN
    IF UPPER(p_action) = 'INSERT' THEN
        INSERT INTO Employees (EMP_ID, Username, Password_Hash, Position, First_Name, Last_Name)
        VALUES (p_emp_id, p_username, p_password, p_position, p_first_name, p_last_name);
        p_result := 'SUCCESS: เพิ่มพนักงานสำเร็จ';

    ELSIF UPPER(p_action) = 'UPDATE' THEN
        -- ถ้าส่งรหัสผ่านมาด้วย ให้เปลี่ยน
        IF p_password IS NOT NULL AND LENGTH(TRIM(p_password)) > 0 THEN
            UPDATE Employees
            SET Username = p_username,
                Password_Hash = p_password,
                Position = p_position,
                First_Name = p_first_name,
                Last_Name = p_last_name
            WHERE TRIM(EMP_ID) = TRIM(p_emp_id);
        ELSE
            UPDATE Employees
            SET Username = p_username,
                Position = p_position,
                First_Name = p_first_name,
                Last_Name = p_last_name
            WHERE TRIM(EMP_ID) = TRIM(p_emp_id);
        END IF;
        p_result := 'SUCCESS: แก้ไขพนักงานสำเร็จ';

    ELSE
        p_result := 'ERROR: action ต้องเป็น INSERT หรือ UPDATE';
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสพนักงานซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
