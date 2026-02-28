-- ===== Batch ของ PUR0000000001 (10-01-2025) =====
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

-- ===== Batch ของ PUR0000000002 (20-02-2025) =====
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

-- ===== Batch ของ PUR0000000003 (15-03-2025) =====
-- 11. Tylenol restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000011', TO_DATE('01/01/2025', 'DD/MM/YYYY'), TO_DATE('01/01/2028', 'DD/MM/YYYY'), 12, 'L_TYL_0002', 80, 80, TO_DATE('17/03/2025', 'DD/MM/YYYY'), 'PRD0000000001', 'PUR0000000003');

-- 12. Amoxil restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000012', TO_DATE('15/12/2024', 'DD/MM/YYYY'), TO_DATE('15/12/2026', 'DD/MM/YYYY'), 45, 'L_AMX_0002', 60, 60, TO_DATE('17/03/2025', 'DD/MM/YYYY'), 'PRD0000000003', 'PUR0000000003');

-- 13. Cemol 500mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000013', TO_DATE('10/02/2025', 'DD/MM/YYYY'), TO_DATE('10/02/2028', 'DD/MM/YYYY'), 10, 'L_CEM_0001', 100, 100, TO_DATE('17/03/2025', 'DD/MM/YYYY'), '8852978007459', 'PUR0000000003');

-- ===== Batch ของ PUR0000000004 (01-04-2025) =====
-- 14. Gofen restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000014', TO_DATE('20/02/2025', 'DD/MM/YYYY'), TO_DATE('20/02/2027', 'DD/MM/YYYY'), 100, 'L_GOF_0002', 40, 40, TO_DATE('03/04/2025', 'DD/MM/YYYY'), 'PRD0000000002', 'PUR0000000004');

-- 15. Zyrtec restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000015', TO_DATE('01/03/2025', 'DD/MM/YYYY'), TO_DATE('01/03/2029', 'DD/MM/YYYY'), 150, 'L_ZYR_0002', 30, 30, TO_DATE('03/04/2025', 'DD/MM/YYYY'), 'PRD0000000005', 'PUR0000000004');

-- ===== Batch ของ PUR0000000005 (18-05-2025) =====
-- 16. Miracid restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000016', TO_DATE('01/04/2025', 'DD/MM/YYYY'), TO_DATE('01/04/2028', 'DD/MM/YYYY'), 60, 'L_MIR_0002', 80, 80, TO_DATE('20/05/2025', 'DD/MM/YYYY'), 'PRD0000000008', 'PUR0000000005');

-- 17. Lipitor restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000017', TO_DATE('15/03/2025', 'DD/MM/YYYY'), TO_DATE('15/03/2027', 'DD/MM/YYYY'), 1000, 'L_LIP_0002', 15, 15, TO_DATE('20/05/2025', 'DD/MM/YYYY'), 'PRD0000000009', 'PUR0000000005');

-- 18. Concor restock
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000018', TO_DATE('01/04/2025', 'DD/MM/YYYY'), TO_DATE('01/04/2028', 'DD/MM/YYYY'), 250, 'L_CON_0002', 40, 40, TO_DATE('20/05/2025', 'DD/MM/YYYY'), 'PRD0000000010', 'PUR0000000005');

-- ===== Batch ของ PUR0000000006 (01-06-2025) =====
-- 19. Aspirin 300mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000019', TO_DATE('01/03/2025', 'DD/MM/YYYY'), TO_DATE('01/03/2028', 'DD/MM/YYYY'), 18, 'L_ASP_0001', 80, 80, TO_DATE('03/06/2025', 'DD/MM/YYYY'), 'PRD0000000011', 'PUR0000000006');

-- 20. Naproxen 250mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000020', TO_DATE('15/04/2025', 'DD/MM/YYYY'), TO_DATE('15/04/2027', 'DD/MM/YYYY'), 70, 'L_NAP_0001', 50, 50, TO_DATE('03/06/2025', 'DD/MM/YYYY'), 'PRD0000000012', 'PUR0000000006');

-- 21. Zithromax 250mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000021', TO_DATE('01/05/2025', 'DD/MM/YYYY'), TO_DATE('01/05/2027', 'DD/MM/YYYY'), 300, 'L_ZIT_0001', 30, 30, TO_DATE('03/06/2025', 'DD/MM/YYYY'), 'PRD0000000013', 'PUR0000000006');

-- 22. Keflex 500mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000022', TO_DATE('20/04/2025', 'DD/MM/YYYY'), TO_DATE('20/04/2027', 'DD/MM/YYYY'), 180, 'L_KEF_0001', 40, 40, TO_DATE('03/06/2025', 'DD/MM/YYYY'), 'PRD0000000014', 'PUR0000000006');

-- 23. Clarityne 10mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000023', TO_DATE('10/05/2025', 'DD/MM/YYYY'), TO_DATE('10/05/2029', 'DD/MM/YYYY'), 130, 'L_CLA_0001', 50, 50, TO_DATE('03/06/2025', 'DD/MM/YYYY'), 'PRD0000000015', 'PUR0000000006');

-- ===== Batch ของ PUR0000000007 (15-07-2025) =====
-- 24. Buscopan 10mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000024', TO_DATE('01/06/2025', 'DD/MM/YYYY'), TO_DATE('01/06/2028', 'DD/MM/YYYY'), 70, 'L_BUS_0001', 60, 60, TO_DATE('17/07/2025', 'DD/MM/YYYY'), 'PRD0000000016', 'PUR0000000007');

-- 25. Smecta 3g
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000025', TO_DATE('15/06/2025', 'DD/MM/YYYY'), TO_DATE('15/06/2028', 'DD/MM/YYYY'), 30, 'L_SME_0001', 80, 80, TO_DATE('17/07/2025', 'DD/MM/YYYY'), 'PRD0000000017', 'PUR0000000007');

-- 26. Norvasc 5mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000026', TO_DATE('01/06/2025', 'DD/MM/YYYY'), TO_DATE('01/06/2027', 'DD/MM/YYYY'), 350, 'L_NOR_0001', 20, 20, TO_DATE('17/07/2025', 'DD/MM/YYYY'), 'PRD0000000018', 'PUR0000000007');

-- 27. Cozaar 50mg
INSERT INTO Product_Batches (Batch_ID, MFG_date, EXP_date, Cost_Price, Lot_Number, Received_Qty, Remaining_Qty, Import_Date, Product_ID, Purchase_ID) 
VALUES ('BCH0000000027', TO_DATE('10/06/2025', 'DD/MM/YYYY'), TO_DATE('10/06/2028', 'DD/MM/YYYY'), 400, 'L_COZ_0001', 20, 20, TO_DATE('17/07/2025', 'DD/MM/YYYY'), 'PRD0000000019', 'PUR0000000007');

COMMIT;