#!/bin/bash

echo "==================================================="
echo "    Pharmacy Management System - Auto Setup (Mac)"
echo "==================================================="
echo ""

# ============================================================
# 0. ตรวจสอบและรันฐานข้อมูลผ่าน Docker (ถ้าระบบมี)
# ============================================================
if command -v docker &> /dev/null && docker compose version &> /dev/null; then
    echo "[OK] ตรวจพบ Docker! กำลังเปิดใช้งานฐานข้อมูล Oracle ให้อัตโนมัติ..."
    docker compose up -d
    echo "---------------------------------------------------"
elif command -v docker-compose &> /dev/null; then
    echo "[OK] ตรวจพบ Docker! กำลังเปิดใช้งานฐานข้อมูล Oracle ให้อัตโนมัติ..."
    docker-compose up -d
    echo "---------------------------------------------------"
else
    echo "[!] ไม่พบ Docker ในการรัน Database อัตโนมัติ (คุณต้องเปิด Oracle ด้วยตัวเอง)"
fi
echo ""

# ============================================================
# 1. ตรวจสอบ Homebrew (จำเป็นสำหรับ Mac)
# ============================================================
if ! command -v brew &> /dev/null; then
    echo "[!] ไม่พบ Homebrew กำลังติดตั้งอัตโนมัติ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # เพิ่ม brew เข้า PATH สำหรับ Apple Silicon หรือ Intel
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo "[OK] ติดตั้ง Homebrew สำเร็จ!"
else
    echo "[OK] พบ Homebrew ในเครื่องแล้ว"
fi

# ============================================================
# 2. ตรวจสอบและติดตั้ง Node.js
# ============================================================
if ! command -v node &> /dev/null; then
    echo "[!] ไม่พบ Node.js กำลังติดตั้งผ่าน Homebrew..."
    brew install node@20
    brew link node@20 --force --overwrite
    echo "[OK] ติดตั้ง Node.js สำเร็จ!"
else
    echo "[OK] พบ Node.js $(node --version) ในเครื่องแล้ว"
fi

# ตรวจสอบอีกรอบว่า node ใช้งานได้จริงหรือไม่
if ! command -v node &> /dev/null; then
    echo "[ERROR] ยังพบ Node.js ไม่ได้ กรุณาปิดแล้วรัน script ใหม่อีกครั้ง"
    echo "[ERROR] หรือติดตั้งด้วยตนเองจาก https://nodejs.org/"
    exit 1
fi

# ============================================================
# 3. ตรวจสอบและติดตั้ง Oracle Instant Client (สำหรับ Mac)
# ============================================================
export ORACLE_DIR="$HOME/oracle_instantclient"
export INSTANT_CLIENT_DIR="$ORACLE_DIR/instantclient_19_8"

if [ -d "$INSTANT_CLIENT_DIR" ]; then
    echo "[OK] พบ Oracle Instant Client ในเครื่องแล้ว ($INSTANT_CLIENT_DIR)"
else
    echo "[!] ไม่พบ Oracle Instant Client กำลังดาวน์โหลดอัตโนมัติ..."
    mkdir -p "$ORACLE_DIR"

    echo "[!] กำลังดาวน์โหลด Oracle Instant Client (Basic package 19.8 for Mac)..."
    curl -L -o "$ORACLE_DIR/instantclient.zip" \
        "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-basic-macos.x64-19.8.0.0.0dbru.zip"

    echo "[!] กำลังแตกไฟล์ไปยัง $ORACLE_DIR..."
    unzip -q "$ORACLE_DIR/instantclient.zip" -d "$ORACLE_DIR"

    # สร้าง symlink สำหรับ libclntsh.dylib บน macOS
    ln -sf "$INSTANT_CLIENT_DIR/libclntsh.dylib.19.1" "$INSTANT_CLIENT_DIR/libclntsh.dylib" 2>/dev/null

    echo "[OK] ติดตั้ง Oracle Instant Client สำเร็จ!"
fi

# ตั้งค่าตัวแปรสำหรับ Oracle บน Mac (สำคัญมาก!)
export DYLD_LIBRARY_PATH="$INSTANT_CLIENT_DIR:$DYLD_LIBRARY_PATH"

# ============================================================
# 4. เข้าไปที่โฟลเดอร์เว็บและเริ่มทำงาน
# ============================================================
cd "$(dirname "$0")/web" || exit 1

echo ""
echo "---------------------------------------------------"

# ตรวจสอบ node_modules
if [ -d "node_modules" ]; then
    echo "[1/3] ตรวจพบ NPM Dependencies ถูกโหลดไว้แล้ว (ข้ามการโหลดซ้ำ)"
else
    echo "[1/3] กำลังติดตั้ง NPM Dependencies ครั้งแรก..."
    npm install
fi

echo ""
echo "[2/3] กำลังเตรียมโครงสร้างฐานข้อมูล (Tables / Mock Data)..."
node setup-db.js

echo ""
echo "[3/3] กำลังเริ่มทำงาน Server..."
echo "==================================================="
npm start
