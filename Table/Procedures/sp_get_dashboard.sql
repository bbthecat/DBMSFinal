-- =====================================================================
-- Procedure: sp_get_dashboard
-- หน้าที่: ดึงข้อมูลสรุปทั้งหมดเพื่อแสดงผลหน้า Dashboard ของแอปพลิเคชัน
-- เทคนิคที่ใช้: การใช้ OUT Parameters แบบ NUMBER และ SYS_REFCURSOR 
--            เพื่อคืนค่า Array/List กลับไปยัง Node.js ภายใน Call เดียว
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_get_dashboard(
    p_today_revenue     OUT NUMBER,
    p_today_count       OUT NUMBER,
    p_product_count     OUT NUMBER,
    p_low_stock_cur     OUT SYS_REFCURSOR,
    p_expiring_cur      OUT SYS_REFCURSOR,
    p_recent_sales_cur  OUT SYS_REFCURSOR
) AS
BEGIN
    -- 1. ยอดขายวันนี้: คำนวณรวมยอดขายจาก Sales_Header เฉพาะวันที่ปัจจุบัน
    SELECT NVL(SUM(Total_Amount), 0), COUNT(*)
    INTO p_today_revenue, p_today_count
    FROM Sales_Header
    WHERE TRUNC(Sale_date) = TRUNC(CAST(CURRENT_TIMESTAMP AS DATE));

    -- จำนวนสินค้าทั้งหมด
    SELECT COUNT(*) INTO p_product_count FROM Product;

    -- 3. สินค้าสต็อกต่ำ (Cursor): หาผลรวมสต็อกคงเหลือทุกล็อตเทียบกับ Reorder_Point
    OPEN p_low_stock_cur FOR
        SELECT p.Product_ID, p.Product_Name, p.Reorder_Point,
               NVL(SUM(pb.Remaining_Qty), 0) AS Current_Stock
        FROM Product p
        LEFT JOIN Product_Batches pb ON p.Product_ID = pb.Product_ID
        GROUP BY p.Product_ID, p.Product_Name, p.Reorder_Point
        HAVING NVL(SUM(pb.Remaining_Qty), 0) < p.Reorder_Point
        ORDER BY NVL(SUM(pb.Remaining_Qty), 0) ASC;

    -- 4. สินค้าใกล้หมดอายุ 90 วัน (Cursor): แจ้งเตือนยาที่ EXP_date ใกล้เข้ามา
    OPEN p_expiring_cur FOR
        SELECT pb.Batch_ID, pb.Lot_Number,
               TO_CHAR(pb.EXP_date, 'YYYY-MM-DD') AS EXP_DATE,
               pb.Remaining_Qty, p.Product_Name,
               ROUND(pb.EXP_date - CAST(CURRENT_TIMESTAMP AS DATE)) AS Days_Left
        FROM Product_Batches pb
        LEFT JOIN Product p ON pb.Product_ID = p.Product_ID
        WHERE pb.EXP_date BETWEEN CAST(CURRENT_TIMESTAMP AS DATE) AND CAST(CURRENT_TIMESTAMP AS DATE) + 90
          AND pb.Remaining_Qty > 0
        ORDER BY pb.EXP_date ASC;

    -- รายการขายล่าสุด 10 รายการ (Cursor)
    OPEN p_recent_sales_cur FOR
        SELECT * FROM (
            SELECT sh.Sale_ID, TO_CHAR(sh.Sale_date, 'YYYY-MM-DD HH24:MI') AS SALE_DATE,
                   sh.Total_Amount, e.First_Name || ' ' || e.Last_Name AS EMP_NAME
            FROM Sales_Header sh
            LEFT JOIN Employees e ON sh.EMP_ID = e.EMP_ID
            ORDER BY sh.Sale_date DESC
        ) WHERE ROWNUM <= 10;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/
