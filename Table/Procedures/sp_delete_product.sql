-- ลบสินค้า พร้อมเช็ค Referential Integrity ก่อนลบ
CREATE OR REPLACE PROCEDURE sp_delete_product(
    p_product_id    IN VARCHAR2,
    p_result        OUT VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    -- เช็คว่ามี Batch อ้างอิงอยู่ไหม
    SELECT COUNT(*) INTO v_count
    FROM Product_Batches
    WHERE TRIM(Product_ID) = TRIM(p_product_id);

    IF v_count > 0 THEN
        p_result := 'ERROR: ไม่สามารถลบได้ เพราะมีล็อตสินค้าอ้างอิงอยู่ (' || v_count || ' ล็อต)';
        RETURN;
    END IF;

    -- เช็ค Purchase Detail
    SELECT COUNT(*) INTO v_count
    FROM Purchase_Detail
    WHERE TRIM(Product_ID) = TRIM(p_product_id);

    IF v_count > 0 THEN
        p_result := 'ERROR: ไม่สามารถลบได้ เพราะมีใบสั่งซื้ออ้างอิงอยู่';
        RETURN;
    END IF;

    DELETE FROM Product WHERE TRIM(Product_ID) = TRIM(p_product_id);
    p_result := 'SUCCESS: ลบสินค้าสำเร็จ';
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
