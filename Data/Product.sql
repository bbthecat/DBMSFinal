-- หมวด C01: ยาแก้ปวดลดไข้
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000001', 'OTC', 'Tylenol 500mg', 'Paracetamol', 50, 15, 10, 'C01');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000002', 'Dangerous Drug', 'Gofen 400', 'Ibuprofen', 20, 120, 10, 'C01');

-- หมวด C02: ยาปฏิชีวนะ
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000003', 'Dangerous Drug', 'Amoxil 500mg', 'Amoxicillin', 30, 60, 10, 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000004', 'Dangerous Drug', 'Augmentin 1g', 'Amoxicillin/Clavulanate', 15, 450, 14, 'C02');

-- หมวด C03: ยาแก้แพ้
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000005', 'OTC', 'Zyrtec 10mg', 'Cetirizine', 20, 180, 10, 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000006', 'OTC', 'CPM 4mg', 'Chlorpheniramine', 100, 10, 100, 'C03');

-- หมวด C04: ยาระบบทางเดินอาหาร
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000007', 'OTC', 'Gaviscon Dual Action', 'Sodium alginate + Antacids', 20, 150, 1, 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000008', 'Dangerous Drug', 'Miracid 20mg', 'Omeprazole', 30, 80, 14, 'C04');

-- หมวด C05: ยาระบบหัวใจและหลอดเลือด (ยาโรคประจำตัว)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000009', 'Dangerous Drug', 'Lipitor 20mg', 'Atorvastatin', 10, 1200, 30, 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000010', 'Dangerous Drug', 'Concor 5mg', 'Bisoprolol', 10, 350, 30, 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('8852978007459', 'OTC', 'Cemol 500mg', 'Paracetamol', 50, 15, 10, 'C01');

commit;