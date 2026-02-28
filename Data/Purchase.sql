INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000001', 'Received', 'INV01', TO_DATE('10-01-2025', 'DD-MM-YYYY'), 5000, 'S01', 'EMP00000-1');

INSERT INTO Purchase_Header (Purchase_ID, Status, Invoice_Number, Purchase_Date, Total_Cost, Supplier_ID, EMP_ID) 
VALUES ('PUR0000000002', 'Received', 'INV02', TO_DATE('20-02-2025', 'DD-MM-YYYY'), 8500, 'S02', 'EMP00000-1');

COMMIT;

-- 1. Tylenol 500mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000001', 100, 12, 'PUR0000000001', 'PRD0000000001');

-- 2. Gofen 400
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000002', 50, 100, 'PUR0000000001', 'PRD0000000002');

-- 3. Amoxil 500mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000003', 50, 45, 'PUR0000000001', 'PRD0000000003');

-- 4. Augmentin 1g
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000004', 30, 350, 'PUR0000000001', 'PRD0000000004');

-- 5. Zyrtec 10mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000005', 40, 150, 'PUR0000000001', 'PRD0000000005');

-- 6. CPM 4mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000006', 200, 5, 'PUR0000000002', 'PRD0000000006');

-- 7. Gaviscon Dual Action
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000007', 60, 120, 'PUR0000000002', 'PRD0000000007');

-- 8. Miracid 20mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000008', 100, 60, 'PUR0000000002', 'PRD0000000008');

-- 9. Lipitor 20mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000009', 20, 1000, 'PUR0000000002', 'PRD0000000009');

-- 10. Concor 5mg
INSERT INTO Purchase_Detail (P_Detail_ID, Order_Qty, Cost_Price, Purchase_ID, Product_ID) 
VALUES ('PDT0000000010', 50, 250, 'PUR0000000002', 'PRD0000000010');

-- บันทึกข้อมูล
COMMIT;