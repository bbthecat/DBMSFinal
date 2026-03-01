@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

echo ===================================================
echo     Pharmacy Management System - Auto Setup And Run
echo ===================================================
echo.

:: 0. ตรวจสอบและรันฐานข้อมูลผ่าน Docker (ถ้าระบบมี)
docker compose version >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] ตรวจพบ Docker! กำลังเปิดใช้งานฐานข้อมูล Oracle ให้อัตโนมัติ...
    docker compose up -d
    echo ---------------------------------------------------
) else (
    where docker-compose >nul 2>nul
    if %errorlevel% equ 0 (
        echo [OK] ตรวจพบ Docker! กำลังเปิดใช้งานฐานข้อมูล Oracle ให้อัตโนมัติ...
        docker-compose up -d
        echo ---------------------------------------------------
    ) else (
        echo [!] ไม่พบ Docker ในการรัน Database อัตโนมัติ (คุณต้องเปิด Oracle ด้วยตัวเอง)
    )
)
echo.

:: 1. ตรวจสอบและติดตั้ง Node.js
where node >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] พบ Node.js ในระบบแล้ว (ผ่าน PATH)
    goto CheckOracle
)

if exist "C:\Program Files\nodejs\node.exe" (
    echo [OK] พบ Node.js ถูกติดตั้งไว้แล้ว (เพิ่มลง PATH ชั่วคราว)
    set "PATH=%PATH%;C:\Program Files\nodejs\"
    goto CheckOracle
)

if exist "C:\nodejs\node-v20.11.1-win-x64\node.exe" (
    echo [OK] พบ Node.js แบบพกพา (Portable) ถูกติดตั้งไว้แล้ว (เพิ่มลง PATH ชั่วคราว)
    set "PATH=%PATH%;C:\nodejs\node-v20.11.1-win-x64"
    goto CheckOracle
)

goto InstallNode

:InstallNode
echo [!] ไม่พบ Node.js ในเครื่อง กำลังดาวน์โหลดแบบพกพา (Portable) อัตโนมัติ (ไม่ต้องกด Yes ยืนยันสิทธิ์)...
set "NODE_DIR=C:\nodejs"
if not exist "!NODE_DIR!" mkdir "!NODE_DIR!"

echo [!] กำลังดาวน์โหลด Node.js...
powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.1/node-v20.11.1-win-x64.zip' -OutFile '%TEMP%\nodejs.zip'"

echo [!] กำลังแตกไฟล์ไปยัง !NODE_DIR!...
powershell -Command "Expand-Archive -Path '%TEMP%\nodejs.zip' -DestinationPath '!NODE_DIR!' -Force"

echo [!] กำลังเพิ่มที่อยู่ไฟล์ลงในตัวแปรระบบ (System PATH)...
powershell -Command "$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User'); $nodePath = 'C:\nodejs\node-v20.11.1-win-x64'; if ($userPath -notlike '*'+$nodePath+'*') { [Environment]::SetEnvironmentVariable('PATH', $userPath + ';' + $nodePath, 'User') }"

set "PATH=%PATH%;C:\nodejs\node-v20.11.1-win-x64"
echo [!] ติดตั้ง Node.js สำเร็จ!

:CheckOracle
:: 2. ตรวจสอบและติดตั้ง Oracle Instant Client (Middleware สำหรับฐานข้อมูล)
where oci.dll >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] พบ Oracle Instant Client ในระบบแล้ว (ผ่าน PATH)
    goto StartWeb
)

if exist "C:\oracle_instantclient\instantclient_19_25\oci.dll" (
    echo [OK] พบ Oracle Instant Client ถูกติดตั้งไว้แล้ว (เพิ่มลง PATH ชั่วคราว)
    set "PATH=%PATH%;C:\oracle_instantclient\instantclient_19_25"
    goto StartWeb
)

if exist "C:\instantclient_23_8\oci.dll" (
    echo [OK] พบ Oracle Instant Client 23_8 ถูกติดตั้งไว้แล้ว (เพิ่มลง PATH ชั่วคราว)
    set "PATH=%PATH%;C:\instantclient_23_8"
    goto StartWeb
)

goto InstallOracle

:InstallOracle
echo [!] ไม่พบ Oracle Instant Client ในเครื่อง (จำเป็นสำหรับการต่อฐานข้อมูล)
set "ORACLE_DIR=C:\oracle_instantclient"
if not exist "!ORACLE_DIR!" mkdir "!ORACLE_DIR!"

echo [!] กำลังดาวน์โหลด Oracle Instant Client (Basic package)...
powershell -Command "Invoke-WebRequest -Uri 'https://download.oracle.com/otn_software/nt/instantclient/1925000/instantclient-basic-windows.x64-19.25.0.0.0dbru.zip' -OutFile '%TEMP%\instantclient.zip'"

echo [!] กำลังแตกไฟล์ไปยัง !ORACLE_DIR!...
powershell -Command "Expand-Archive -Path '%TEMP%\instantclient.zip' -DestinationPath '!ORACLE_DIR!' -Force"

echo [!] กำลังเพิ่มที่อยู่ไฟล์ลงในตัวแปรระบบ (System PATH)...
powershell -Command "$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User'); $oraclePath = 'C:\oracle_instantclient\instantclient_19_25'; if ($userPath -notlike '*'+$oraclePath+'*') { [Environment]::SetEnvironmentVariable('PATH', $userPath + ';' + $oraclePath, 'User') }"

:: ตั้งค่าลง PATH เพื่อให้รันในเซสชันปัจุบันได้
set "PATH=%PATH%;C:\oracle_instantclient\instantclient_19_25"
echo [!] ติดตั้ง Oracle Instant Client สำเร็จ!

:StartWeb
:: 3. เข้าไปที่โฟลเดอร์รหัสผ่านเว็บและรัน
cd web

echo.
echo [1/3] กำลังตรวจสอบและติดตั้ง NPM Dependencies...
call npm install

echo.
echo [2/3] กำลังเตรียมโครงสร้างฐานข้อมูล (Tables / Mock Data)...
node setup-db.js

echo.
echo [3/3] กำลังเริ่มทำงาน Server...
echo ===================================================
call npm start

pause
