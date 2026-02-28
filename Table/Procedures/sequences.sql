-- ============================================================
-- Sequences สำหรับสร้าง ID อัตโนมัติ
-- ใช้ NEXTVAL ใน Stored Procedure แทน generate จาก JavaScript
-- ============================================================

-- ลำดับสำหรับ Sale_ID (SAL0000000001, SAL0000000002, ...)
CREATE SEQUENCE seq_sale START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Sale Detail_ID (SDT0000000001, ...)
CREATE SEQUENCE seq_sale_detail START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Purchase_ID (PUR0000000001, ...)
CREATE SEQUENCE seq_purchase START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Purchase Detail_ID (PDT0000000001, ...)
CREATE SEQUENCE seq_purchase_detail START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Batch_ID (BAT0000000001, ...)
CREATE SEQUENCE seq_batch START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Product_ID (PRD0000000001, ...)
CREATE SEQUENCE seq_product START WITH 100 INCREMENT BY 1 NOCACHE;
/

-- ลำดับสำหรับ Employee_ID (EMP0000001, ...)
CREATE SEQUENCE seq_employee START WITH 100 INCREMENT BY 1 NOCACHE;
/
