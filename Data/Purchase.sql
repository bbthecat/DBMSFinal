-- ===== Purchase_Header =====
INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000001', 'Received', 'INV01', TO_DATE('10-01-2025', 'DD-MM-YYYY'), 5000, 'S01', 'EMP00000-1');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000002', 'Received', 'INV02', TO_DATE('20-02-2025', 'DD-MM-YYYY'), 8500, 'S02', 'EMP00000-1');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000003', 'Received', 'INV03', TO_DATE('15-03-2025', 'DD-MM-YYYY'), 6200, 'S03', 'EMP00000-1');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000004', 'Received', 'INV04', TO_DATE('01-04-2025', 'DD-MM-YYYY'), 3500, 'S04', 'EMP00000-2');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000005', 'Received', 'INV05', TO_DATE('18-05-2025', 'DD-MM-YYYY'), 9000, 'S05', 'EMP00000-2');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000006', 'Received', 'INV06', TO_DATE('01-06-2025', 'DD-MM-YYYY'), 7350, 'S06', 'EMP00000-1');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000007', 'Received', 'INV07', TO_DATE('15-07-2025', 'DD-MM-YYYY'), 11900, 'S03', 'EMP00000-2');

COMMIT;

-- ===== Purchase_Detail =====
-- PUR0000000001: Tylenol, Gofen, Amoxil, Augmentin, Zyrtec (จาก S01)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000001', 100, 12, 'PUR0000000001', 'PRD0000000001');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000002', 50, 100, 'PUR0000000001', 'PRD0000000002');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000003', 50, 45, 'PUR0000000001', 'PRD0000000003');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000004', 30, 350, 'PUR0000000001', 'PRD0000000004');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000005', 40, 150, 'PUR0000000001', 'PRD0000000005');

-- PUR0000000002: CPM, Gaviscon, Miracid, Lipitor, Concor (จาก S02)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000006', 200, 5, 'PUR0000000002', 'PRD0000000006');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000007', 60, 120, 'PUR0000000002', 'PRD0000000007');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000008', 100, 60, 'PUR0000000002', 'PRD0000000008');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000009', 20, 1000, 'PUR0000000002', 'PRD0000000009');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000010', 50, 250, 'PUR0000000002', 'PRD0000000010');

-- PUR0000000003: Tylenol restock, Amoxil restock, Cemol (จาก S03)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000011', 80, 12, 'PUR0000000003', 'PRD0000000001');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000012', 60, 45, 'PUR0000000003', 'PRD0000000003');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000013', 100, 10, 'PUR0000000003', '8852978007459');

-- PUR0000000004: Gofen restock, Zyrtec restock (จาก S04)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000014', 40, 100, 'PUR0000000004', 'PRD0000000002');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000015', 30, 150, 'PUR0000000004', 'PRD0000000005');

-- PUR0000000005: Miracid restock, Lipitor restock, Concor restock (จาก S05)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000016', 80, 60, 'PUR0000000005', 'PRD0000000008');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000017', 15, 1000, 'PUR0000000005', 'PRD0000000009');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000018', 40, 250, 'PUR0000000005', 'PRD0000000010');

-- PUR0000000006: Aspirin, Naproxen, Zithromax, Keflex, Clarityne (จาก S06)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000019', 80, 18, 'PUR0000000006', 'PRD0000000011');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000020', 50, 70, 'PUR0000000006', 'PRD0000000012');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000021', 30, 300, 'PUR0000000006', 'PRD0000000013');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000022', 40, 180, 'PUR0000000006', 'PRD0000000014');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000023', 50, 130, 'PUR0000000006', 'PRD0000000015');

-- PUR0000000007: Buscopan, Smecta, Norvasc, Cozaar (จาก S03)
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000024', 60, 70, 'PUR0000000007', 'PRD0000000016');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000025', 80, 30, 'PUR0000000007', 'PRD0000000017');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000026', 20, 350, 'PUR0000000007', 'PRD0000000018');

INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000027', 20, 400, 'PUR0000000007', 'PRD0000000019');

COMMIT;