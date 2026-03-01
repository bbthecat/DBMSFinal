-- สร้างตาราง Audit Log
CREATE TABLE Product_Audit_Log (
    Log_ID      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Action_Type VARCHAR2(50),
    Product_ID  CHAR(13),
    Product_Name VARCHAR2(100),
    Changed_By  VARCHAR2(100) DEFAULT USER,
    Changed_At  TIMESTAMP DEFAULT SYSTIMESTAMP,
    Old_Price   NUMBER,
    New_Price   NUMBER,
    Details     VARCHAR2(500)
);
