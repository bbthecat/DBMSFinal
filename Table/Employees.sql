CREATE TABLE Employees (
	EMP_ID			char(10),
	Password_Hash	varchar2(100),
	Username		varchar2(100),
	Position		varchar2(100),
	First_Name		varchar2(100),
	Last_Name		varchar2(100),
	CONSTRAINTS	Empk	PRIMARY KEY (EMP_ID)
);