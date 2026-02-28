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

-- เพิ่มเติม C01: ยาแก้ปวดลดไข้
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000011', 'OTC', 'Aspirin 300mg', 'Acetylsalicylic Acid', 40, 25, 10, 'C01');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000012', 'Dangerous Drug', 'Naproxen 250mg', 'Naproxen', 20, 90, 10, 'C01');

-- เพิ่มเติม C02: ยาปฏิชีวนะ
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000013', 'Dangerous Drug', 'Zithromax 250mg', 'Azithromycin', 15, 380, 6, 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000014', 'Dangerous Drug', 'Keflex 500mg', 'Cephalexin', 20, 250, 10, 'C02');

-- เพิ่มเติม C03: ยาแก้แพ้
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000015', 'OTC', 'Clarityne 10mg', 'Loratadine', 30, 160, 10, 'C03');

-- เพิ่มเติม C04: ยาระบบทางเดินอาหาร
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000016', 'Dangerous Drug', 'Buscopan 10mg', 'Hyoscine Butylbromide', 25, 95, 10, 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000017', 'OTC', 'Smecta 3g', 'Diosmectite', 20, 45, 10, 'C04');

-- เพิ่มเติม C05: ยาระบบหัวใจและหลอดเลือด
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000018', 'Dangerous Drug', 'Norvasc 5mg', 'Amlodipine', 10, 450, 30, 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('PRD0000000019', 'Dangerous Drug', 'Cozaar 50mg', 'Losartan', 10, 550, 30, 'C05');

-- Barcode product
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Unit_per_pack, Category_ID) 
VALUES ('8852978007459', 'OTC', 'Cemol 500mg', 'Paracetamol', 50, 15, 10, 'C01');

commit;