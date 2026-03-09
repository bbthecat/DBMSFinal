#!/bin/bash

echo "==================================================="
echo "    Pharmacy Management System - Auto Setup (Mac)"
echo "==================================================="
echo ""

# ============================================================
# 1. ตรวจสอบและติดตั้ง Homebrew (จำเป็นสำหรับทุกอย่างบน Mac)
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
# 2. ตรวจสอบและติดตั้ง Docker Desktop
# ============================================================
if ! command -v docker &> /dev/null; then
    echo "[!] ไม่พบ Docker กำลังติดตั้ง Docker Desktop ผ่าน Homebrew..."
    brew install --cask docker
    echo "[OK] ติดตั้ง Docker Desktop สำเร็จ!"
    echo "[!] กำลังเปิด Docker Desktop รอสักครู่..."
    open /Applications/Docker.app
    # รอให้ Docker daemon พร้อมทำงาน (สูงสุด 60 วินาที)
    echo "[!] รอให้ Docker พร้อมทำงาน..."
    for i in $(seq 1 12); do
        if docker info &> /dev/null; then
            echo "[OK] Docker พร้อมทำงานแล้ว!"
            break
        fi
        echo "    (รอ... $((i*5))/60 วินาที)"
        sleep 5
    done
else
    echo "[OK] พบ Docker ในเครื่องแล้ว"
    # เปิด Docker Desktop ถ้ายังไม่รัน
    if ! docker info &> /dev/null; then
        echo "[!] Docker ยังไม่ได้รัน กำลังเปิด Docker Desktop..."
        open /Applications/Docker.app
        echo "[!] รอให้ Docker พร้อมทำงาน..."
        for i in $(seq 1 12); do
            if docker info &> /dev/null; then
                echo "[OK] Docker พร้อมทำงานแล้ว!"
                break
            fi
            echo "    (รอ... $((i*5))/60 วินาที)"
            sleep 5
        done
    fi
fi

# ============================================================
# 3. เปิดฐานข้อมูล Oracle ผ่าน Docker
# ============================================================
echo ""
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if docker compose version &> /dev/null; then
    echo "[OK] กำลังเปิดใช้งานฐานข้อมูล Oracle..."
    docker compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
elif command -v docker-compose &> /dev/null; then
    echo "[OK] กำลังเปิดใช้งานฐานข้อมูล Oracle..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
else
    echo "[!] Docker ยังพร้อมใช้งานไม่ได้ โปรดเปิด Docker Desktop แล้วรัน script ใหม่"
    exit 1
fi
echo "---------------------------------------------------"
echo ""

# ============================================================
# 4. ตรวจสอบและติดตั้ง Node.js
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
# 5. (Removed) ไม่จำเป็นต้องใช้ Oracle Instant Client สำหรับ oracledb เวอร์ชัน 6+ (Thin Mode)
# ============================================================

# ============================================================
# 6. เข้าไปที่โฟลเดอร์เว็บและเริ่มทำงาน
# ============================================================
cd "$SCRIPT_DIR/web" || exit 1

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
