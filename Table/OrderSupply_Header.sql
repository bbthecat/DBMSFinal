CREATE TABLE OrderSupply_Header (
    Order_ID        char(10),
    Ordered_Date     DATE DEFAULT SYSDATE,
    Supplier_ID      char(3),
    CONSTRAINTS OrSup_pk PRIMARY KEY (Order_ID),
    CONSTRAINTS OrSup_Supplier_fk FOREIGN KEY (Supplier_ID)
        REFERENCES Supplier(Supplier_ID)
);
