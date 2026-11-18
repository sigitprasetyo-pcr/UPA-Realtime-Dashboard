#!/bin/bash
# ============================================================
# Script Deploy UPA Realtime Dashboard di Server 172.16.9.6
# Jalankan: bash deploy-server.sh
# ============================================================

set -e

echo "======================================================"
echo " UPA Realtime Dashboard - Deploy ke Server"
echo " Frontend : http://172.16.9.6:1035"
echo " API      : http://172.16.9.6:8080"
echo " DB UNRI  : 172.16.9.8 (SLiMS:24002, Skripsi:23601)"
echo "======================================================"

# Stop & hapus container lama
echo "[1/5] Menghentikan container lama..."
docker compose down --remove-orphans 2>/dev/null || true

# Hapus image lama agar rebuild bersih
echo "[2/5] Menghapus image lama..."
docker rmi upa-realtime-dashboard-frontend upa-realtime-dashboard-upa-api 2>/dev/null || true

# Build ulang image
echo "[3/5] Build ulang semua image..."
docker compose build --no-cache

# Jalankan semua service
echo "[4/5] Menjalankan semua service..."
docker compose up -d

# Tunggu service siap
echo "[5/5] Menunggu service siap..."
sleep 15

# Test koneksi
echo ""
echo "======================================================"
echo " Status Container:"
docker compose ps
echo ""
echo " Test API Ping:"
curl -s http://localhost:8080/index.php?endpoint=ping | python3 -m json.tool 2>/dev/null || \
  curl -s http://localhost:8080/index.php?endpoint=ping
echo ""
echo "======================================================"
echo " DEPLOY SELESAI!"
echo " Akses dashboard: http://172.16.9.6:1035"
echo " Login: admin@upa.unri.ac.id / admin123"
echo "======================================================"
