CREATE TABLE Product_Batches (
	Batch_ID		char(13),
	MFG_date		DATE,
	EXP_date		DATE,
	Cost_Price		number,
	Lot_Number		char(10),
	Received_Qty	number,
	Remaining_Qty	number,
	Import_Date		DATE SYS DATE,
	Product_ID		char(13),
	Purchase_ID		char(13),
	CONSTRAINT batch_PK	PRIMARY KEY (Batch_ID),
	CONSTRAINT Prod_batch_FK	FOREIGN KEY (Product_ID)
	REFERENCES Product (Product_ID),
	CONSTRAINT Purc_head_batch_FK FOREIGN KEY (Purchase_ID)
	REFERENCES Purchase_Header (Purchase_ID)
);