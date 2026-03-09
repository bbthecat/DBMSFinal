select * from Category;
select * from Product;
select * from Supplier;
select * from Employees;
select * from Stocks;
select * from Shelf;
select * from Purchase_Header;
select * from Purchase_Detail;
select * from Product_Batches;

ALTER TABLE Product_Batches
MODIFY (
    Import_Date DATE DEFAULT SYSDATE
);

ALTER TABLE Sales_Header
MODIFY (
    Sale_date DATE DEFAULT SYSDATE
);

CREATE USER dbms_dev IDENTIFIED BY 1234;


GRANT CONNECT, RESOURCE TO dbms_dev;


ALTER USER dbms_dev QUOTA UNLIMITED ON USERS;

ALTER TRIGGER DBMS_DEV.TRG_LOW_STOCK_ALERT DISABLE;

ALTER TRIGGER DBMS_DEV.TRG_LOW_STOCK_ALERT COMPILE;
SHOW ERRORS;

SHOW ERRORS TRIGGER DBMS_DEV.TRG_LOW_STOCK_ALERT;

-- 1. ลบจากรายการขายก่อน
DELETE FROM Sales_Detail;

-- 2. ลบจากรายการสั่งซื้อ
DELETE FROM PURCHASE_HEADER;

-- 3. ลบจากล็อตยา
DELETE FROM Product_Batches;

-- 4. ลองลบจาก Log (ถ้ารันแล้ว Error แสดงว่ายังไม่ได้สร้างตารางนี้ ให้ข้ามไปเลย)
DELETE FROM Stock_Alert_Log;
DELETE FROM Product_Audit_Log;

-- 5. สุดท้าย ลบข้อมูล Master ยา 
-- (ลองบรรทัดใดบรรทัดหนึ่ง ตามชื่อที่คุณตั้งไว้ตอน CREATE TABLE)
DELETE FROM Product;    -- ถ้าตอนสร้างไม่มี s ใช้บรรทัดนี้
-- DELETE FROM Products; -- ถ้าตอนสร้างมี s ใช้บรรทัดนี้

-- 6. เซฟข้อมูล
COMMIT;

SELECT * FROM Product;