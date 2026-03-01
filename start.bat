@echo off
chcp 65001 > nul
echo ===================================================
echo     Pharmacy Management System - Startup Script
echo ===================================================
echo.

:: เข้าไปที่โฟลเดอร์ web
cd web

:: ตรวจสอบและติดตั้ง dependencies ถ้ายังไม่มี
echo [1/2] กำลังตรวจสอบและติดตั้ง Dependencies (npm install)...
call npm install

echo.
echo [2/2] กำลังเริ่มทำงาน Server (npm start)...
echo ===================================================
call npm start

:: ถ้า server หยุดทำงาน จะให้กดปุ่มหยุดหน้าต่างไว้ ไม่ให้ปิดทันที
pause
