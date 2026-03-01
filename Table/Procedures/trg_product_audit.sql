-- Trigger: บันทึก Log เมื่อมีการเปลี่ยนแปลงข้อมูลสินค้า (Audit Trail)
-- INSERT / UPDATE / DELETE จะถูกบันทึกลงตาราง Product_Audit_Log

CREATE OR REPLACE TRIGGER trg_product_audit
AFTER INSERT OR UPDATE OR DELETE ON Product
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Product_Audit_Log (Action_Type, Product_ID, Product_Name, New_Price, Details)
        VALUES ('INSERT', :NEW.Product_ID, :NEW.Product_Name, :NEW.Unit_Price,
                'เพิ่มสินค้าใหม่: ' || :NEW.Product_Name);

    ELSIF UPDATING THEN
        INSERT INTO Product_Audit_Log (Action_Type, Product_ID, Product_Name, Old_Price, New_Price, Details)
        VALUES ('UPDATE', :NEW.Product_ID, :NEW.Product_Name, :OLD.Unit_Price, :NEW.Unit_Price,
                'แก้ไขสินค้า: ' || :OLD.Product_Name || ' → ' || :NEW.Product_Name);

    ELSIF DELETING THEN
        INSERT INTO Product_Audit_Log (Action_Type, Product_ID, Product_Name, Old_Price, Details)
        VALUES ('DELETE', :OLD.Product_ID, :OLD.Product_Name, :OLD.Unit_Price,
                'ลบสินค้า: ' || :OLD.Product_Name);
    END IF;
END;
/
