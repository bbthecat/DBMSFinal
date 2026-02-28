CREATE TABLE Product (
	Product_ID		char(13),
	Drug_type		varchar2(100),
	Product_Name 	varchar2(100),
	Generic_Name	varchar2(100),
	Reorder_Point	number,
	Unit_Price		number,
	Unit_per_pack	number,
	Category_ID		char(3),
	CONSTRAINT Prod_PK	PRIMARY KEY (Product_ID),
	CONSTRAINT cate_fk	FOREIGN KEY (Category_ID)
	REFERENCES Category (Category_ID)
);