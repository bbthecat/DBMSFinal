CREATE TABLE Sales_Header (
    Sale_ID CHAR(13),
    Sale_date Date,
    Total_Amount NUMBER,
    EMP_ID CHAR(10),
    CONSTRAINT SaleH_pk PRIMARY KEY (Sale_ID),
    CONSTRAINT Emp_fk_Sale FOREIGN KEY (EMP_ID)
		REFERENCES Employees (EMP_ID)
);

CREATE TABLE Sales_Detail (
    Detail_ID CHAR(13),
    Quantity  NUMBER,
	Subtotal NUMBER,
	Unit_Price NUMBER,
	Discount NUMBER,
	Sale_ID CHAR(13),
	Batch_ID CHAR(13),
	CONSTRAINT Detail_pk PRIMARY KEY (Detail_ID),
	CONSTRAINT D_fk_Header FOREIGN KEY (Sale_ID)
		REFERENCES Sales_Header (Sale_ID),
	CONSTRAINT D_fk_B FOREIGN KEY (Batch_ID)
		REFERENCES Product_Batches (Batch_ID)
);