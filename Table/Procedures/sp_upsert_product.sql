-- เพิ่มหรือแก้ไขสินค้า (p_action = 'INSERT' หรือ 'UPDATE')
CREATE OR REPLACE PROCEDURE sp_upsert_product(
    p_product_id    IN VARCHAR2,
    p_drug_type     IN VARCHAR2,
    p_product_name  IN VARCHAR2,
    p_generic_name  IN VARCHAR2,
    p_reorder_point IN NUMBER,
    p_unit_price    IN NUMBER,
    p_unit_per_pack IN NUMBER,
    p_category_id   IN VARCHAR2,
    p_action        IN VARCHAR2,
    p_result        OUT VARCHAR2
) AS
BEGIN
    IF UPPER(p_action) = 'INSERT' THEN
        INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name,
                             Reorder_Point, Unit_Price, Unit_per_pack, Category_ID)
        VALUES (p_product_id, p_drug_type, p_product_name, p_generic_name,
                p_reorder_point, p_unit_price, p_unit_per_pack, p_category_id);
        p_result := 'SUCCESS: เพิ่มสินค้าสำเร็จ';

    ELSIF UPPER(p_action) = 'UPDATE' THEN
        UPDATE Product
        SET Drug_type = p_drug_type,
            Product_Name = p_product_name,
            Generic_Name = p_generic_name,
            Reorder_Point = p_reorder_point,
            Unit_Price = p_unit_price,
            Unit_per_pack = p_unit_per_pack,
            Category_ID = p_category_id
        WHERE TRIM(Product_ID) = TRIM(p_product_id);
        p_result := 'SUCCESS: แก้ไขสินค้าสำเร็จ';

    ELSE
        p_result := 'ERROR: action ต้องเป็น INSERT หรือ UPDATE';
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสสินค้าซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
