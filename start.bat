@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

echo ===================================================
echo     Pharmacy Management System - Auto Setup ^& Run
echo ===================================================
echo.

:: 1. ตรวจสอบและติดตั้ง Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] ไม่พบ Node.js ในเครื่อง กำลังดาวน์โหลดและติดตั้ง (อาจใช้เวลาสักครู่)...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi' -OutFile '%TEMP%\nodejs_installer.msi'"
    echo [!] กำลังติดตั้ง Node.js... (กรุณากด Yes หากมีกล่องข้อความแจ้งเตือน)
    msiexec /i "%TEMP%\nodejs_installer.msi" /passive
    echo [!] ติดตั้ง Node.js สำเร็จ!
    
    :: เพิ่มลงใน PATH ชั่วคราวเพื่อให้รันคำสั่ง npm ในหน้าต่างนี้ได้เลย
    set "PATH=%PATH%;C:\Program Files\nodejs\"
) else (
    echo [OK] พบ Node.js ในเครื่องแล้ว
)

:: 2. ตรวจสอบและติดตั้ง Oracle Instant Client (Middleware สำหรับฐานข้อมูล)
where oci.dll >nul 2>nul
if %errorlevel% neq 0 (
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
) else (
    echo [OK] พบ Oracle Instant Client แล้ว
)

:: 3. เข้าไปที่โฟลเดอร์รหัสผ่านเว็บและรัน
cd web

echo.
echo [1/2] กำลังตรวจสอบและติดตั้ง NPM Dependencies...
call npm install

echo.
echo [2/2] กำลังเริ่มทำงาน Server...
echo ===================================================
call npm start

pause
