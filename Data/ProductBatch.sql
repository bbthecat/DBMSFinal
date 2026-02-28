-- 1. Tylenol 500mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000001', TO_DATE('01/05/2024', 'DD/MM/YYYY'), TO_DATE('01/05/2027', 'DD/MM/YYYY'), 12, 'L_TYL_0001', 100, 100, TO_DATE('12/01/2025', 'DD/MM/YYYY'), 'PRD0000000001', 'PUR0000000001');

-- 2. Gofen 400
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000002', TO_DATE('15/06/2024', 'DD/MM/YYYY'), TO_DATE('15/06/2026', 'DD/MM/YYYY'), 100, 'L_GOF_0001', 50, 50, TO_DATE('12/01/2025', 'DD/MM/YYYY'), 'PRD0000000002', 'PUR0000000001');

-- 3. Amoxil 500mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000003', TO_DATE('10/08/2024', 'DD/MM/YYYY'), TO_DATE('10/08/2026', 'DD/MM/YYYY'), 45, 'L_AMX_0001', 50, 50, TO_DATE('12/01/2025', 'DD/MM/YYYY'), 'PRD0000000003', 'PUR0000000001');

-- 4. Augmentin 1g
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000004', TO_DATE('01/09/2024', 'DD/MM/YYYY'), TO_DATE('01/09/2025', 'DD/MM/YYYY'), 350, 'L_AUG_0001', 30, 30, TO_DATE('12/01/2025', 'DD/MM/YYYY'), 'PRD0000000004', 'PUR0000000001');

-- 5. Zyrtec 10mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000005', TO_DATE('20/01/2024', 'DD/MM/YYYY'), TO_DATE('20/01/2028', 'DD/MM/YYYY'), 150, 'L_ZYR_0001', 40, 40, TO_DATE('12/01/2025', 'DD/MM/YYYY'), 'PRD0000000005', 'PUR0000000001');

-- 6. CPM 4mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000006', TO_DATE('05/11/2024', 'DD/MM/YYYY'), TO_DATE('05/11/2029', 'DD/MM/YYYY'), 5, 'L_CPM_0001', 200, 200, TO_DATE('22/02/2025', 'DD/MM/YYYY'), 'PRD0000000006', 'PUR0000000002');

-- 7. Gaviscon Dual Action
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000007', TO_DATE('15/10/2024', 'DD/MM/YYYY'), TO_DATE('15/10/2026', 'DD/MM/YYYY'), 120, 'L_GAV_0001', 60, 60, TO_DATE('22/02/2025', 'DD/MM/YYYY'), 'PRD0000000007', 'PUR0000000002');

-- 8. Miracid 20mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000008', TO_DATE('01/12/2024', 'DD/MM/YYYY'), TO_DATE('01/12/2027', 'DD/MM/YYYY'), 60, 'L_MIR_0001', 100, 100, TO_DATE('22/02/2025', 'DD/MM/YYYY'), 'PRD0000000008', 'PUR0000000002');

-- 9. Lipitor 20mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000009', TO_DATE('20/07/2024', 'DD/MM/YYYY'), TO_DATE('20/07/2026', 'DD/MM/YYYY'), 1000, 'L_LIP_0001', 20, 20, TO_DATE('22/02/2025', 'DD/MM/YYYY'), 'PRD0000000009', 'PUR0000000002');

-- 10. Concor 5mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000010', TO_DATE('25/08/2024', 'DD/MM/YYYY'), TO_DATE('25/08/2027', 'DD/MM/YYYY'), 250, 'L_CON_0001', 50, 50, TO_DATE('22/02/2025', 'DD/MM/YYYY'), 'PRD0000000010', 'PUR0000000002');

-- บันทึกข้อมูล
COMMIT;