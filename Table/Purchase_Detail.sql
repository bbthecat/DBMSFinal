CREATE TABLE Purchase_Detail (
	P_Detail_ID		char(13),
	Order_Qty		number,
	Cost_Price		number,
	Purchase_ID		char(13),
	Product_ID		char(13),
	CONSTRAINT Purc_detail_PK	PRIMARY KEY (P_Detail_ID),
	CONSTRAINT	Purc_head_FK	FOREIGN KEY (Purchase_ID)
	REFERENCES	Purchase_Header (Purchase_ID),
	CONSTRAINT Prod_FK	FOREIGN KEY (Product_ID)
	REFERENCES	Product (Product_ID)
);