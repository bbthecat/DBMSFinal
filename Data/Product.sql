-- 1. แบบแผง (1 Pack มี 10 แผง)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000020', 'OTC', 'Sara 500mg (แผง)', 'Paracetamol', 50, 15, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 เม็ด)', 'C01');

-- 2. แบบกระปุก S (1 Pack มี 4 กระปุก)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000021', 'OTC', 'Sara 500mg (กระปุก S)', 'Paracetamol', 20, 40, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C01');

-- 3. แบบกระปุก M (1 Pack มี 2 กระปุก)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000022', 'OTC', 'Sara 500mg (กระปุก M)', 'Paracetamol', 20, 50, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C01');

-- 4. แบบกระปุก L (1 Pack มี 1 กระปุก)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000023', 'OTC', 'Sara 500mg (กระปุก L)', 'Paracetamol', 15, 70, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C01');

-- 5. แบบน้ำ (1 Pack มี 1 ขวด)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000024', 'OTC', 'Sara Syrup for Kids', 'Paracetamol', 30, 35, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ขนาด 60 ml)', 'C01');

-- 6. แบบเม็ด (แบ่งขาย)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000025', 'OTC', 'Paracetamol 500mg (แบ่งขาย)', 'Paracetamol', 500, 2, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C01');

--------------------------------------------------------------------------

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000026', 'Dangerous Drug', 'Amoxil 500mg (แผง)', 'Amoxicillin', 50, 60, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 เม็ด)', 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000027', 'Dangerous Drug', 'Amoxil 500mg (กระปุก S)', 'Amoxicillin', 20, 150, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000028', 'Dangerous Drug', 'Amoxil 500mg (กระปุก M)', 'Amoxicillin', 20, 200, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000029', 'Dangerous Drug', 'Amoxil 500mg (กระปุก L)', 'Amoxicillin', 15, 280, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000030', 'Dangerous Drug', 'Amoxil Dry Syrup', 'Amoxicillin', 30, 65, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำแขวนตะกอน)', 'C02');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000031', 'Dangerous Drug', 'Amoxicillin 500mg (แบ่งขาย)', 'Amoxicillin', 100, 6, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C02');

--------------------------------------------------------------------------

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000032', 'OTC', 'Zyrtec 10mg (แผง)', 'Cetirizine', 30, 180, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 เม็ด)', 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000033', 'OTC', 'Zyrtec 10mg (กระปุก S)', 'Cetirizine', 15, 450, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000034', 'OTC', 'Zyrtec 10mg (กระปุก M)', 'Cetirizine', 15, 600, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000035', 'OTC', 'Zyrtec 10mg (กระปุก L)', 'Cetirizine', 10, 850, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000036', 'OTC', 'Zyrtec Syrup', 'Cetirizine', 20, 200, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำเชื่อม 75 ml)', 'C03');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000037', 'OTC', 'Cetirizine 10mg (แบ่งขาย)', 'Cetirizine', 100, 18, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C03');

--------------------------------------------------------------------------

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000038', 'Dangerous Drug', 'Miracid 20mg (แผง)', 'Omeprazole', 40, 80, 14, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 14 เม็ด)', 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000039', 'Dangerous Drug', 'Miracid 20mg (กระปุก S)', 'Omeprazole', 20, 150, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000040', 'Dangerous Drug', 'Miracid 20mg (กระปุก M)', 'Omeprazole', 20, 190, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000041', 'Dangerous Drug', 'Miracid 20mg (กระปุก L)', 'Omeprazole', 15, 270, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000042', 'Dangerous Drug', 'Miracid Suspension', 'Omeprazole', 15, 120, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำแขวนตะกอน 60 ml)', 'C04');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000043', 'Dangerous Drug', 'Omeprazole 20mg (แบ่งขาย)', 'Omeprazole', 140, 6, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C04');
--------------------------------------------------------------------------

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000044', 'Dangerous Drug', 'Norvasc 5mg (แผง)', 'Amlodipine', 30, 150, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 เม็ด)', 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000045', 'Dangerous Drug', 'Norvasc 5mg (กระปุก S)', 'Amlodipine', 15, 420, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000046', 'Dangerous Drug', 'Norvasc 5mg (กระปุก M)', 'Amlodipine', 15, 550, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000047', 'Dangerous Drug', 'Norvasc 5mg (กระปุก L)', 'Amlodipine', 10, 800, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000048', 'Dangerous Drug', 'Amlodipine Syrup', 'Amlodipine', 10, 250, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำ 100 ml)', 'C05');

INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000049', 'Dangerous Drug', 'Amlodipine 5mg (แบ่งขาย)', 'Amlodipine', 90, 15, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C05');

--------------------------------------------------------------------------

-- 1. แบบแผง 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000050', 'Specially Controlled Drug', 'Tramadol 50mg (แผง)', 'Tramadol HCl', 20, 100, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 เม็ด)', 'C01');

-- 2. แบบกระปุก S 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000051', 'Specially Controlled Drug', 'Tramadol 50mg (กระปุก S)', 'Tramadol HCl', 10, 280, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 เม็ด)', 'C01');

-- 3. แบบกระปุก M 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000052', 'Specially Controlled Drug', 'Tramadol 50mg (กระปุก M)', 'Tramadol HCl', 10, 350, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 เม็ด)', 'C01');

-- 4. แบบกระปุก L 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000053', 'Specially Controlled Drug', 'Tramadol 50mg (กระปุก L)', 'Tramadol HCl', 5, 500, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 เม็ด)', 'C01');

-- 5. แบบน้ำ (ชนิดหยด)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000054', 'Specially Controlled Drug', 'Tramadol Drops', 'Tramadol HCl', 5, 200, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาหยด 10 ml)', 'C01');

-- 6. แบบเม็ด (แบ่งขาย)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000055', 'Specially Controlled Drug', 'Tramadol 50mg (แบ่งขาย)', 'Tramadol HCl', 50, 10, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นเม็ด (ราคาต่อ 1 เม็ด)', 'C01');

-----------------------------------------------------------------------------
-- 1. แบบแผง 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000056', 'Herbal Medicine', 'Turmeric (แผง)', 'Curcuma Longa', 50, 80, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 แคปซูล)', 'C04');

-- 2. แบบกระปุก S 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000057', 'Herbal Medicine', 'Turmeric (กระปุก S)', 'Curcuma Longa', 30, 220, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 แคปซูล)', 'C04');

-- 3. แบบกระปุก M 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000058', 'Herbal Medicine', 'Turmeric (กระปุก M)', 'Curcuma Longa', 20, 280, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 แคปซูล)', 'C04');

-- 4. แบบกระปุก L 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000059', 'Herbal Medicine', 'Turmeric (กระปุก L)', 'Curcuma Longa', 15, 400, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 แคปซูล)', 'C04');

-- 5. แบบน้ำ (ยาน้ำขับลม)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000060', 'Herbal Medicine', 'Turmeric Mixture', 'Curcuma Longa', 20, 120, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำ 120 ml)', 'C04');

-- 6. แบบเม็ด (แบ่งขาย)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000061', 'Herbal Medicine', 'Turmeric (แบ่งขาย)', 'Curcuma Longa', 100, 5, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นแคปซูล (ราคาต่อ 1 แคปซูล)', 'C04');

--------------------------------------------------------------------------

-- 1. แบบแผง 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000062', 'Supplement', 'Fish Oil 1000mg (แผง)', 'Omega-3', 40, 150, 10, 10, 10, 'แผง', '1 Pack บรรจุ 10 แผง (แผงละ 10 แคปซูล)', 'C05');

-- 2. แบบกระปุก S 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000063', 'Supplement', 'Fish Oil 1000mg (กระปุก S)', 'Omega-3', 20, 400, 30, 4, 10, 'กระปุก(S)', '1 Pack บรรจุ 4 กระปุก (กระปุกละ 30 แคปซูล)', 'C05');

-- 3. แบบกระปุก M 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000064', 'Supplement', 'Fish Oil 1000mg (กระปุก M)', 'Omega-3', 15, 520, 40, 2, 10, 'กระปุก(M)', '1 Pack บรรจุ 2 กระปุก (กระปุกละ 40 แคปซูล)', 'C05');

-- 4. แบบกระปุก L 
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000065', 'Supplement', 'Fish Oil 1000mg (กระปุก L)', 'Omega-3', 10, 750, 60, 1, 10, 'กระปุก(L)', '1 Pack บรรจุ 1 กระปุก (กระปุกละ 60 แคปซูล)', 'C05');

-- 5. แบบน้ำ (สำหรับเด็ก)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000066', 'Supplement', 'Fish Oil Syrup', 'Omega-3', 15, 250, 1, 1, 10, 'แบบน้ำ', '1 Pack บรรจุ 1 ขวด (ยาน้ำ 150 ml)', 'C05');

-- 6. แบบเม็ด (แบ่งขาย)
INSERT INTO Product (Product_ID, Drug_type, Product_Name, Generic_Name, Reorder_Point, Unit_Price, Pill_per_unit, Unit_per_pack, Pack_per_box, Package, Description, Category_ID) 
VALUES ('PRD0000000067', 'Supplement', 'Fish Oil 1000mg (แบ่งขาย)', 'Omega-3', 100, 12, 1, 1, 0, 'เม็ด(Pill)', 'แบ่งขายเป็นแคปซูล (ราคาต่อ 1 แคปซูล)', 'C05');

--------------------------------------------------------------------------

commit;
