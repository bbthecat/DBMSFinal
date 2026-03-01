-- View: สรุปยอดขายรายเดือน
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT 
    TO_CHAR(sh.Sale_date, 'YYYY-MM') AS Sale_Month,
    TO_CHAR(sh.Sale_date, 'Month', 'NLS_DATE_LANGUAGE=THAI') AS Month_Name,
    COUNT(*) AS Sale_Count,
    NVL(SUM(sh.Total_Amount), 0) AS Total_Revenue,
    COUNT(DISTINCT sh.EMP_ID) AS Emp_Count
FROM Sales_Header sh
GROUP BY TO_CHAR(sh.Sale_date, 'YYYY-MM'), TO_CHAR(sh.Sale_date, 'Month', 'NLS_DATE_LANGUAGE=THAI')
ORDER BY Sale_Month DESC
/

-- View: สรุปสต็อกสินค้าทั้งหมด
CREATE OR REPLACE VIEW v_stock_summary AS
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Generic_Name,
    c.Category_Name,
    p.Drug_type,
    p.Unit_Price,
    p.Reorder_Point,
    NVL(SUM(pb.Remaining_Qty), 0) AS Total_Stock,
    COUNT(pb.Batch_ID) AS Batch_Count,
    MIN(pb.EXP_date) AS Nearest_Expiry,
    CASE 
        WHEN NVL(SUM(pb.Remaining_Qty), 0) = 0 THEN 'หมดสต็อก'
        WHEN NVL(SUM(pb.Remaining_Qty), 0) < p.Reorder_Point THEN 'สต็อกต่ำ'
        ELSE 'ปกติ'
    END AS Stock_Status
FROM Product p
LEFT JOIN Category c ON p.Category_ID = c.Category_ID
LEFT JOIN Product_Batches pb ON p.Product_ID = pb.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Generic_Name, c.Category_Name,
         p.Drug_type, p.Unit_Price, p.Reorder_Point
ORDER BY Total_Stock ASC
/

-- View: สินค้าขายดี
CREATE OR REPLACE VIEW v_top_products AS
SELECT 
    p.Product_Name,
    p.Generic_Name,
    SUM(sd.Quantity) AS Total_Sold,
    SUM(sd.Subtotal) AS Total_Revenue,
    COUNT(DISTINCT sd.Sale_ID) AS Times_Sold
FROM Sales_Detail sd
JOIN Product_Batches pb ON sd.Batch_ID = pb.Batch_ID
JOIN Product p ON pb.Product_ID = p.Product_ID
GROUP BY p.Product_Name, p.Generic_Name
ORDER BY Total_Sold DESC
/
