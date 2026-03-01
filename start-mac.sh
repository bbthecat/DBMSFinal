#!/bin/bash

echo "==================================================="
echo "    Pharmacy Management System - Auto Setup (Mac)"
echo "==================================================="
echo ""

# 1. Check for Homebrew (essential for Mac setup)
if ! command -v brew &> /dev/null; then
    echo "[!] ไม่พบ Homebrew ในเครื่อง (จำเป็นสำหรับติดตั้งโปรแกรมบน Mac)"
    echo "[!] กำลังติดตั้ง Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to path for Apple Silicon or Intel
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "[OK] พบ Homebrew ในเครื่องแล้ว"
fi

# 2. Check and install Node.js
if ! command -v node &> /dev/null; then
    echo "[!] ไม่พบ Node.js กำลังติดตั้งผ่าน Homebrew..."
    brew install node
    echo "[!] ติดตั้ง Node.js สำเร็จ!"
else
    echo "[OK] พบ Node.js ในเครื่องแล้ว"
fi

# 3. Check and install Oracle Instant Client (macOS)
# Node.js oracledb module on macOS actually requires the Instant Client to be downloaded and unzipped.
# We will download it to ~/Downloads/oracle_instantclient and set DYLD_LIBRARY_PATH
export ORACLE_DIR="$HOME/oracle_instantclient"
export INSTANT_CLIENT_DIR="$ORACLE_DIR/instantclient_19_8"

if [ ! -d "$INSTANT_CLIENT_DIR" ]; then
    echo "[!] ไม่พบ Oracle Instant Client สำหรับ macOS"
    echo "[!] กำลังสร้างโฟลเดอร์ $ORACLE_DIR..."
    mkdir -p "$ORACLE_DIR"
    
    echo "[!] กำลังดาวน์โหลด Oracle Instant Client (Basic package 19.8 for Mac)..."
    curl -o "$ORACLE_DIR/instantclient.zip" "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-basic-macos.x64-19.8.0.0.0dbru.zip"
    
    echo "[!] กำลังแตกไฟล์..."
    unzip -q "$ORACLE_DIR/instantclient.zip" -d "$ORACLE_DIR"
    
    # Create necessary symlink for libclntsh.dylib on macOS
    ln -s "$INSTANT_CLIENT_DIR/libclntsh.dylib.19.1" "$INSTANT_CLIENT_DIR/libclntsh.dylib" 2>/dev/null
    
    echo "[!] ติดตั้ง Oracle Instant Client (Mac) สำเร็จ!"
    echo "[!] หมายเหตุ: ห้ามลบโฟลเดอร์ $ORACLE_DIR"
else
    echo "[OK] พบ Oracle Instant Client ในเครื่องแล้ว"
fi

# Set crucial environment variable for Oracle on Mac
export DYLD_LIBRARY_PATH="$INSTANT_CLIENT_DIR:$DYLD_LIBRARY_PATH"

# 4. Enter the web directory and start
cd web || exit

echo ""
echo "[1/3] กำลังตรวจสอบและติดตั้ง NPM Dependencies..."
npm install

echo ""
echo "[2/3] กำลังเตรียมโครงสร้างฐานข้อมูล (Tables / Mock Data)..."
node setup-db.js

echo ""
echo "[3/3] กำลังเริ่มทำงาน Server..."
echo "==================================================="
npm start
