-- เพิ่มรายการสินค้าในใบสั่งซื้อ
CREATE OR REPLACE PROCEDURE sp_add_purchase_item(
    p_purchase_id   IN VARCHAR2,
    p_product_id    IN VARCHAR2,
    p_order_qty     IN NUMBER,
    p_cost_price    IN NUMBER,
    p_detail_id     OUT VARCHAR2,
    p_result        OUT VARCHAR2
) AS
BEGIN
    p_detail_id := 'D' || TO_CHAR(SYSTIMESTAMP, 'HH24MISSFF6');
    p_detail_id := SUBSTR(p_detail_id, 1, 13);
    
    INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID)
    VALUES (p_detail_id, p_order_qty, p_cost_price, p_purchase_id, p_product_id);

    p_result := 'SUCCESS';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_result := 'ERROR: รหัสรายการซ้ำ';
    WHEN OTHERS THEN
        p_result := 'ERROR: ' || SQLERRM;
END;
/
