CREATE TABLE Supplier(
    Supplier_ID CHAR(3),
    Supplier_Name VARCHAR2(100),
    Contract VARCHAR2(100),
    CONSTRAINTS Supplier_pk PRIMARY KEY (Supplier_ID)
);

INSERT INTO Supplier VALUES ('S01','Sara_supply','Sara_supple co.');

SELECT * FROM SUPPLIER;

UPDATE SUPPLIER SET CONTRACT = 'Sara_supply co.'
WHERE CONTRACT = 'Sara_supple co.';