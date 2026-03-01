-- ============================================================
-- ตารางเก็บประวัติการแจ้งเตือนสต็อกต่ำ
-- ============================================================
CREATE TABLE Stock_Alert_Log (
    Alert_ID        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Product_ID      CHAR(13),
    Product_Name    VARCHAR2(100),
    Current_Stock   NUMBER,
    Reorder_Point   NUMBER,
    Alert_Date      DATE DEFAULT SYSDATE
);
