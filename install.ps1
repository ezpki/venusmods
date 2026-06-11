$ErrorActionPreference = "Stop"
Write-Host "======================================" -ForegroundColor Magenta
Write-Host "  Memulai Instalasi VenusMods Premium " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Magenta
Write-Host ""

# 1. Mengecek dan Menginstal Millennium (Core Engine Steam)
Write-Host "[1/4] Mengecek sistem Millennium di Steam..." -ForegroundColor Yellow
try {
    Write-Host "Mengunduh dan memasang Millennium (jika belum ada)..." -ForegroundColor Cyan
    # Menjalankan penginstal resmi Millennium secara otomatis
    iex (irm https://millennium.web.app/install.ps1)
    Write-Host "Mesin Millennium siap!" -ForegroundColor Green
} catch {
    Write-Host "Peringatan: Gagal memverifikasi Millennium, mencoba melanjutkan..." -ForegroundColor Red
}
Write-Host ""

# 2. Mencari Lokasi Steam di Komputer Pengguna
Write-Host "[2/4] Mencari direktori Steam..." -ForegroundColor Yellow
$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue).SteamPath

if (-not $steamPath) {
    Write-Host "ERROR: Steam tidak ditemukan di sistem ini!" -ForegroundColor Red
    return
}
$steamPath = $steamPath -replace '/', '\'
Write-Host "Steam ditemukan di: $steamPath" -ForegroundColor Green

# 3. Menyiapkan Folder Plugin
$pluginDir = "$steamPath\steamui\plugins\VenusMods" 
if (-not (Test-Path $pluginDir)) {
    New-Item -Path $pluginDir -ItemType Directory -Force | Out-Null
}

# 4. Mengunduh File ZIP dari GitHub
Write-Host "[3/4] Mengunduh paket sistem VenusMods..." -ForegroundColor Yellow

# =========================================================
# PERHATIAN: GANTI URL DI BAWAH DENGAN URL ZIP GITHUB MILIKMU
$zipUrl = "https://github.com/ezpki/venusmods/raw/refs/heads/main/venusmods.zip"
# =========================================================

$tempZip = "$env:TEMP\VenusMods_Temp.zip"

try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
    Write-Host "Paket berhasil diunduh!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Gagal mengunduh paket. Pastikan koneksi internet stabil." -ForegroundColor Red
    return
}

# 5. Mengekstrak ZIP ke Folder Steam
Write-Host "[4/4] Memasang VenusMods ke dalam Steam..." -ForegroundColor Yellow
try {
    # Ekstrak dan timpa (force) jika sudah ada file lama
    Expand-Archive -Path $tempZip -DestinationPath $pluginDir -Force
    # Hapus file ZIP sementara
    Remove-Item -Path $tempZip -Force
} catch {
    Write-Host "ERROR: Gagal mengekstrak file." -ForegroundColor Red
    return
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Magenta
Write-Host "INSTALASI SELESAI & BERHASIL!" -ForegroundColor Green
Write-Host "Silakan Buka/Restart Steam Anda." -ForegroundColor Cyan
Write-Host "Klik logo Kunci (🔑) di pojok kanan atas Steam untuk memasukkan" -ForegroundColor Cyan
Write-Host "Kunci Lisensi Premium Anda." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Magenta