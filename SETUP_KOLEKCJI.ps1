# ============================================================
#  KOCIA INWENTARYZACJA - Setup kolekcji w PocketBase
#  Uruchom PO tym jak:
#    1. Serwer dziala (START_SERWER.ps1)
#    2. Masz juz konto admina w panelu
# ============================================================

param(
    [string]$PbUrl    = "http://127.0.0.1:8090",
    [string]$Email    = "slicznykotuni@gmail.com",
    [string]$Password = "Monster_36"
)

Write-Host ""
Write-Host "  /\_/\  SETUP KOLEKCJI PocketBase" -ForegroundColor Yellow
Write-Host " ( ^.^ )" -ForegroundColor Yellow
Write-Host ""

# Pobierz dane admina jesli nie podane jako parametry
if (-not $Email) {
    $Email = Read-Host "Email admina PocketBase"
}
if (-not $Password) {
    $SecPass = Read-Host "Haslo admina" -AsSecureString
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass))
}

$headers = @{ "Content-Type" = "application/json" }

# ---- LOGOWANIE ----
Write-Host "[~] Loguję się do PocketBase..." -ForegroundColor Cyan
try {
    $loginBody = @{ identity = $Email; password = $Password } | ConvertTo-Json
    $loginResp = Invoke-RestMethod -Uri "$PbUrl/api/admins/auth-with-password" `
        -Method POST -Headers $headers -Body $loginBody
    $token = $loginResp.token
    $headers["Authorization"] = "Bearer $token"
    Write-Host "[+] Zalogowano!" -ForegroundColor Green
} catch {
    Write-Host "[!] Błąd logowania: $_" -ForegroundColor Red
    Read-Host "Naciśnij Enter"; exit 1
}

# ---- DEFINICJA KOLEKCJI ----
$sprzet = @{
    name     = "sprzet"
    type     = "base"
    schema   = @(
        @{ name="nazwa";         type="text";   required=$true; options=@{min=1;max=200} }
        @{ name="kategoria";     type="select"; required=$false; options=@{maxSelect=1; values=@("komputer","monitor","serwer","siec","peryferium","telefon","kabel","narzedzie","inne")} }
        @{ name="lokalizacja";   type="select"; required=$false; options=@{maxSelect=1; values=@("sala","magazyn","szafa","biurko")} }
        @{ name="producent";     type="text";   required=$false; options=@{max=100} }
        @{ name="model";         type="text";   required=$false; options=@{max=100} }
        @{ name="numer_seryjny"; type="text";   required=$false; options=@{max=200} }
        @{ name="numer_inw";     type="text";   required=$false; options=@{max=100} }
        @{ name="rok";           type="number"; required=$false; options=@{min=1990;max=2100;noDecimal=$true} }
        @{ name="ilosc";         type="number"; required=$false; options=@{min=1;noDecimal=$true} }
        @{ name="stan_fizyczny"; type="select"; required=$false; options=@{maxSelect=1; values=@("dobry","dostateczny","zly","sprawdzic")} }
        @{ name="stan_tech";     type="select"; required=$false; options=@{maxSelect=1; values=@("dobry","dostateczny","zly","sprawdzic")} }
        @{ name="kompletnosc";   type="select"; required=$false; options=@{maxSelect=1; values=@("dobry","dostateczny","zly")} }
        @{ name="zalecenie";     type="select"; required=$false; options=@{maxSelect=1; values=@("zostaje","naprawic","wyrzucic","decyzja")} }
        @{ name="uwagi";         type="text";   required=$false; options=@{max=2000} }
        @{ name="sprawdzil";     type="text";   required=$false; options=@{max=100} }
        @{ name="zdjecia";       type="file";   required=$false; options=@{maxSelect=5; maxSize=5242880; mimeTypes=@("image/jpeg","image/png","image/webp","image/gif")} }
    )
    listRule   = ""
    viewRule   = ""
    createRule = ""
    updateRule = ""
    deleteRule = ""
} | ConvertTo-Json -Depth 10

# ---- SPRAWDZ CZY KOLEKCJA JUZ ISTNIEJE ----
Write-Host "[~] Sprawdzam istniejące kolekcje..." -ForegroundColor Cyan
try {
    $existing = Invoke-RestMethod -Uri "$PbUrl/api/collections/sprzet" -Headers $headers -ErrorAction Stop
    Write-Host "[=] Kolekcja 'sprzet' już istnieje. Pomijam tworzenie." -ForegroundColor Yellow
    $collectionId = $existing.id
} catch {
    # Utwórz kolekcję
    Write-Host "[~] Tworzę kolekcję 'sprzet'..." -ForegroundColor Cyan
    try {
        $created = Invoke-RestMethod -Uri "$PbUrl/api/collections" `
            -Method POST -Headers $headers -Body $sprzet
        $collectionId = $created.id
        Write-Host "[+] Kolekcja 'sprzet' utworzona! ID: $collectionId" -ForegroundColor Green
    } catch {
        Write-Host "[!] Błąd tworzenia kolekcji: $_" -ForegroundColor Red
        Read-Host "Naciśnij Enter"; exit 1
    }
}

# ---- IMPORT Z JSON (opcjonalny) ----
Write-Host ""
$doImport = Read-Host "Czy chcesz zaimportować dane z backup JSON? (t/n)"
if ($doImport -eq "t") {
    $jsonPath = Read-Host "Podaj ścieżkę do pliku backup JSON"
    if (Test-Path $jsonPath) {
        Write-Host "[~] Wczytuję $jsonPath..." -ForegroundColor Cyan
        $jsonData = Get-Content $jsonPath -Encoding UTF8 | ConvertFrom-Json
        $ok = 0; $err = 0
        foreach ($item in $jsonData) {
            $rec = @{
                nazwa         = $item.nazwa
                kategoria     = $item.kategoria
                lokalizacja   = $item.lokalizacja
                producent     = $item.producent
                model         = $item.model
                numer_seryjny = $item.numerSeryjny
                numer_inw     = $item.numerInw
                rok           = if ($item.rok) { [int]$item.rok } else { $null }
                ilosc         = if ($item.ilosc) { [int]$item.ilosc } else { 1 }
                stan_fizyczny = $item.stanFizyczny
                stan_tech     = $item.stanTechniczny
                kompletnosc   = $item.kompletnosc
                zalecenie     = $item.zalecenie
                uwagi         = $item.uwagi
                sprawdzil     = $item.sprawdzil
            }
            # usuń puste wartości null
            $recClean = @{}
            $rec.GetEnumerator() | Where-Object { $_.Value -ne $null -and $_.Value -ne "" } | ForEach-Object { $recClean[$_.Key] = $_.Value }
            try {
                Invoke-RestMethod -Uri "$PbUrl/api/collections/sprzet/records" `
                    -Method POST -Headers $headers -Body ($recClean | ConvertTo-Json) | Out-Null
                $ok++
            } catch { $err++ }
        }
        Write-Host "[+] Import: $ok ok, $err błędów" -ForegroundColor $(if($err -gt 0){"Yellow"}else{"Green"})
    } else {
        Write-Host "[!] Nie znaleziono pliku." -ForegroundColor Red
    }
}

# ---- KONIEC ----
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Konfiguracja zakończona!" -ForegroundColor Green
Write-Host "  Aplikacja: otwórz INWENTARYZACJA.html" -ForegroundColor White
Write-Host "  Panel PB:  $PbUrl/_/" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Read-Host "Naciśnij Enter aby zakończyć"
