# ============================================================
#  KOCIA INWENTARYZACJA - Serwer PocketBase
#  Uruchom jako Administrator (PPM -> Uruchom jako administrator)
# ============================================================

# Ustawienie kodowania na UTF8, żeby polskie znaki nie psuły składni
$OutputEncoding = [System.Text.Encoding]::UTF8

$PB_VERSION = "0.22.18"
$PB_DIR     = "$PSScriptRoot\pocketbase"
$PB_EXE     = "$PB_DIR\pocketbase.exe"
$PB_URL     = "https://github.com/pocketbase/pocketbase/releases/download/v$PB_VERSION/pocketbase_${PB_VERSION}_windows_amd64.zip"
$PB_ZIP     = "$PB_DIR\pb.zip"

Write-Host ""
Write-Host "  / \_/ \  KOCIA INWENTARYZACJA - Serwer" -ForegroundColor Yellow
Write-Host " (  o.o  )  PocketBase v$PB_VERSION" -ForegroundColor Yellow
Write-Host "  >  nn <  Windows LAN Setup" -ForegroundColor Yellow
Write-Host ""

# 1. Utwórz folder jeśli nie istnieje
if (-not (Test-Path $PB_DIR)) {
    try {
        New-Item -ItemType Directory -Path $PB_DIR -ErrorAction Stop | Out-Null
        Write-Host "[+] Utworzono folder: $PB_DIR" -ForegroundColor Green
    } catch {
        Write-Host "[!] Nie udalo sie utworzyc folderu: $_" -ForegroundColor Red
    }
}

# 2. Pobierz PocketBase jeśli nie ma exe
if (-not (Test-Path $PB_EXE)) {
    Write-Host "[~] Pobieranie PocketBase $PB_VERSION..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $PB_URL -OutFile $PB_ZIP -UseBasicParsing
        Write-Host "[+] Pobrano. Rozpakowuje..." -ForegroundColor Green
        Expand-Archive -Path $PB_ZIP -DestinationPath $PB_DIR -Force
        Remove-Item $PB_ZIP
        Write-Host "[+] PocketBase gotowy!" -ForegroundColor Green
    } catch {
        Write-Host "[!] Blad pobierania: $_" -ForegroundColor Red
        Write-Host "    Pobierz recznie z: https://pocketbase.io/docs/" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "[=] PocketBase juz zainstalowany." -ForegroundColor Green
}

# 3. Znajdz lokalny adres IP
$LocalIP = (Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*" } | 
    Select-Object -First 1).IPAddress

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  Serwer startuje na:" -ForegroundColor White
# Używamy $($variable) dla bezpieczeństwa i unikamy znaku < który psuł skrypt
Write-Host "  http://$($LocalIP):8090   --- KOTKI WCHODZA TUTAJ" -ForegroundColor Cyan
Write-Host "  http://$($LocalIP):8090/_/  --- Panel admina" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# 4. Dodaj regule zapory (Admin required)
try {
    $rule = Get-NetFirewallRule -DisplayName "PocketBase Kocia Inwentaryzacja" -ErrorAction SilentlyContinue
    if (-not $rule) {
        New-NetFirewallRule -DisplayName "PocketBase Kocia Inwentaryzacja" `
            -Direction Inbound -Protocol TCP -LocalPort 8090 -Action Allow | Out-Null
        Write-Host "[+] Dodano regule zapory dla portu 8090" -ForegroundColor Green
    }
} catch {
    Write-Host "[!] Uwaga: Uruchom jako Admin, aby dodac wyjatek do zapory (Firewall)." -ForegroundColor Yellow
}

# 5. Uruchom PocketBase
if (Test-Path $PB_EXE) {
    Set-Location $PB_DIR
    Write-Host "[*] Uruchamianie serwera... (Ctrl+C aby przerwac)" -ForegroundColor Gray
    & $PB_EXE serve --http="0.0.0.0:8090"
} else {
    Write-Host "[!] Nie znaleziono pliku: $PB_EXE" -ForegroundColor Red
    Read-Host "Nacisnij Enter aby wyjsc"
}