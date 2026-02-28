-- สร้างใบสั่งซื้อใหม่ พร้อมคำนวณยอดรวม
CREATE OR REPLACE PROCEDURE sp_create_purchase(
    p_purchase_id   IN VARCHAR2,
    p_invoice       IN VARCHAR2,
    p_supplier_id   IN VARCHAR2,
    p_emp_id        IN VARCHAR2,
    p_total_cost    IN NUMBER,
    p_result        OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID)
    VALUES (p_purchase_id, 'รอรับสินค้า', p_invoice, SYSDATE, p_total_cost, p_supplier_id, p_emp_id);

    p_result := 'SUCCESS';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสใบสั่งซื้อซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
