@echo off
chcp 65001 > nul

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
        echo [!] ไม่พบ Docker ในการรัน Database อัตโนมัติ ^(คุณต้องเปิด Oracle ด้วยตัวเอง^)
    )
)
echo.

:: ============================================================
:: 1. ตรวจสอบและติดตั้ง Node.js
:: ============================================================
where node >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] พบ Node.js ในระบบแล้ว
    goto CheckOracle
)

if exist "C:\Program Files\nodejs\node.exe" (
    echo [OK] พบ Node.js ถูกติดตั้งไว้แล้ว
    set "PATH=C:\Program Files\nodejs;%PATH%"
    goto CheckOracle
)

:: ถ้ายังไม่เจอ Node.js เลย ให้ดาวน์โหลดและติดตั้ง
echo [!] ไม่พบ Node.js ในเครื่อง กำลังดาวน์โหลดอัตโนมัติ...
echo [!] กำลังดาวน์โหลด Node.js v24.14.0 (อาจใช้เวลาสักครู่)...
powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v24.14.0/node-v24.14.0-x64.msi' -OutFile '%TEMP%\nodejs.msi'"

echo [!] กำลังติดตั้ง Node.js... (อาจมีกล่องข้อความเด้งขึ้นมาให้กด Yes เพื่อยืนยันสิทธิ์)
msiexec /i "%TEMP%\nodejs.msi" /passive /norestart

:: รอให้ติดตั้งเสร็จแล้วเช็คว่าไฟล์มาจริง
echo [!] กำลังรอให้ติดตั้งเสร็จ...
timeout /t 5 /nobreak >nul

if exist "C:\Program Files\nodejs\node.exe" (
    echo [OK] ติดตั้ง Node.js สำเร็จ!
    set "PATH=C:\Program Files\nodejs;%PATH%"
) else (
    echo [ERROR] ติดตั้ง Node.js ไม่สำเร็จ กรุณาติดตั้ง Node.js ด้วยตนเอง
    echo [ERROR] ดาวน์โหลดได้ที่: https://nodejs.org/
    pause
    exit /b 1
)

:: ============================================================
:: 2. ตรวจสอบและติดตั้ง Oracle Instant Client
:: ============================================================
:CheckOracle
where oci.dll >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] พบ Oracle Instant Client ในระบบแล้ว
    goto StartWeb
)

if exist "C:\oracle_instantclient\instantclient_19_25\oci.dll" (
    echo [OK] พบ Oracle Instant Client 19_25 ถูกติดตั้งไว้แล้ว
    set "PATH=C:\oracle_instantclient\instantclient_19_25;%PATH%"
    goto StartWeb
)

if exist "C:\instantclient_23_8\oci.dll" (
    echo [OK] พบ Oracle Instant Client 23_8 ถูกติดตั้งไว้แล้ว
    set "PATH=C:\instantclient_23_8;%PATH%"
    goto StartWeb
)

:: ถ้ายังไม่เจอ Oracle Instant Client เลย ให้ดาวน์โหลดและติดตั้ง
setlocal EnableDelayedExpansion
echo [!] ไม่พบ Oracle Instant Client ในเครื่อง
set "ORACLE_DIR=C:\oracle_instantclient"
if not exist "!ORACLE_DIR!" mkdir "!ORACLE_DIR!"

echo [!] กำลังดาวน์โหลด Oracle Instant Client (อาจใช้เวลาสักครู่)...
powershell -Command "Invoke-WebRequest -Uri 'https://download.oracle.com/otn_software/nt/instantclient/1925000/instantclient-basic-windows.x64-19.25.0.0.0dbru.zip' -OutFile '%TEMP%\instantclient.zip'"

echo [!] กำลังแตกไฟล์...
powershell -Command "Expand-Archive -Path '%TEMP%\instantclient.zip' -DestinationPath '!ORACLE_DIR!' -Force"

echo [!] กำลังเพิ่มลงในตัวแปรระบบ (System PATH)...
powershell -Command "$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User'); $oraclePath = 'C:\oracle_instantclient\instantclient_19_25'; if ($userPath -notlike '*'+$oraclePath+'*') { [Environment]::SetEnvironmentVariable('PATH', $userPath + ';' + $oraclePath, 'User') }"
endlocal

set "PATH=C:\oracle_instantclient\instantclient_19_25;%PATH%"
echo [OK] ติดตั้ง Oracle Instant Client สำเร็จ!

:: ============================================================
:: 3. เริ่มต้นรัน Web Server
:: ============================================================
:StartWeb
:: บังคับเพิ่ม PATH ให้ชัวร์อีกครั้ง (กันกรณี PATH หลุดจาก setlocal)
set "PATH=C:\Program Files\nodejs;%PATH%"

cd web

echo.
echo ---------------------------------------------------

:: ตรวจสอบว่า node ใช้งานได้จริงหรือไม่
node --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] ยังไม่พบ Node.js ในเครื่องแม้จะพยายามติดตั้งแล้ว
    echo [ERROR] กรุณาปิดหน้าต่างนี้แล้วรัน start.bat ใหม่อีกครั้ง
    echo [ERROR] หรือติดตั้ง Node.js ด้วยตัวเองจาก https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js พร้อมใช้งาน!

:: ตรวจสอบว่าเคยโหลด Dependencies ไว้หรือยัง
if exist "node_modules\" goto SkipNpmInstall

echo [1/3] กำลังติดตั้ง NPM Dependencies ครั้งแรก...
call npm install
goto DoneNpmInstall

:SkipNpmInstall
echo [1/3] ตรวจพบ NPM Dependencies ถูกโหลดไว้แล้ว (ข้ามการโหลดซ้ำ)

:DoneNpmInstall
echo.
echo [2/3] กำลังเตรียมโครงสร้างฐานข้อมูล (Tables / Mock Data)...
node setup-db.js

echo.
echo [3/3] กำลังเริ่มทำงาน Server...
echo ===================================================
call npm start

pause
