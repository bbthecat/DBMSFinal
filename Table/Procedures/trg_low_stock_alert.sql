-- Trigger: แจ้งเตือนเมื่อสต็อกต่ำกว่า Reorder Point หลังขาย
-- ใช้ Compound Trigger เพื่อแก้ปัญหา Mutating Table (ORA-04091)

CREATE OR REPLACE TRIGGER trg_low_stock_alert
FOR UPDATE OF Remaining_Qty ON Product_Batches
COMPOUND TRIGGER

    TYPE t_product_ids IS TABLE OF Product_Batches.Product_ID%TYPE;
    g_product_ids t_product_ids := t_product_ids();

    -- AFTER EACH ROW: เก็บ Product_ID ที่ถูกอัพเดท
    AFTER EACH ROW IS
    BEGIN
        g_product_ids.EXTEND;
        g_product_ids(g_product_ids.COUNT) := :NEW.Product_ID;
    END AFTER EACH ROW;

    -- AFTER STATEMENT: เช็คสต็อกรวมหลังจาก UPDATE เสร็จ (ไม่ mutate)
    AFTER STATEMENT IS
        v_total_stock   NUMBER;
        v_reorder_point NUMBER;
        v_product_name  VARCHAR2(100);
        v_exists        NUMBER;
    BEGIN
        FOR i IN 1..g_product_ids.COUNT LOOP
            SELECT NVL(SUM(Remaining_Qty), 0)
            INTO v_total_stock
            FROM Product_Batches
            WHERE Product_ID = g_product_ids(i);

            SELECT Reorder_Point, Product_Name
            INTO v_reorder_point, v_product_name
            FROM Product
            WHERE Product_ID = g_product_ids(i);

            IF v_total_stock < v_reorder_point THEN
                SELECT COUNT(*) INTO v_exists
                FROM Stock_Alert_Log
                WHERE Product_ID = g_product_ids(i)
                  AND TRUNC(Alert_Date) = TRUNC(SYSDATE);

                IF v_exists = 0 THEN
                    INSERT INTO Stock_Alert_Log (Product_ID, Product_Name, Current_Stock, Reorder_Point)
                    VALUES (g_product_ids(i), v_product_name, v_total_stock, v_reorder_point);
                END IF;
            END IF;
        END LOOP;
    END AFTER STATEMENT;

END trg_low_stock_alert;
/
