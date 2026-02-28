CREATE TABLE Purchase_Header (
	Purchase_ID		char(13),
	Status			varchar2(100),
	Invoice_Number	char(5),
	Purchase_Date	DATE,
	Total_Cost		number,
	Supplier_ID		char(3),
	EMP_ID			char(10),
	CONSTRAINT	Purc_head_PK	PRIMARY KEY (Purchase_ID),
	CONSTRAINT supfk		FOREIGN KEY (Supplier_ID)
	REFERENCES	Supplier (Supplier_ID),
	CONSTRAINT empfk		FOREIGN KEY (EMP_ID)
	REFERENCES	Employees (EMP_ID)
);