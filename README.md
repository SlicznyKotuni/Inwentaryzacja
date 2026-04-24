# 🐱 Kocia Inwentaryzacja INF.02 — v3 PocketBase

## Co jest w tym pakiecie?

```
📁 kocia-inwentaryzacja-pb/
 ├── START_SERWER.ps1      ← Uruchamia serwer PocketBase (raz, na głównym PC)
 ├── SETUP_KOLEKCJI.ps1    ← Konfiguruje bazę danych (jednorazowo)
 ├── INWENTARYZACJA.html   ← Główna aplikacja (otwierają wszyscy kotki)
 └── README.md             ← Ten plik
```
<img width="1811" height="879" alt="image" src="https://github.com/user-attachments/assets/8f8c606c-996e-4e71-b15a-009c9ae82e26" />

---

## Pierwsze uruchomienie (krok po kroku)

### Krok 1 — Uruchom serwer PocketBase

1. Kliknij **prawym** na `START_SERWER.ps1`
2. Wybierz **„Uruchom za pomocą PowerShell"**
   - Jeśli pojawi się ostrzeżenie o polityce — kliknij "Uruchom i tak"
   - Jeśli pyta o uprawnienia administratora — kliknij "Tak"
3. Skrypt automatycznie:
   - Pobierze PocketBase (~30MB) jeśli go nie ma
   - Doda regułę zapory dla portu 8090
   - Wyświetli adres IP serwera

> ⚠️ **Zostaw to okno otwarte przez całą inwentaryzację!**

### Krok 2 — Utwórz konto admina

1. Otwórz przeglądarkę na **tym samym komputerze**
2. Wejdź na: `http://127.0.0.1:8090/_/`
3. Utwórz konto admina (email + hasło — zapamiętaj!)

### Krok 3 — Skonfiguruj kolekcję bazy

1. Kliknij prawym na `SETUP_KOLEKCJI.ps1` → Uruchom w PowerShell
2. Podaj email i hasło admina z kroku 2
3. Skrypt automatycznie utworzy kolekcję `sprzet` ze wszystkimi polami
4. Opcjonalnie: zaimportuj dane z backup JSON ze starej wersji aplikacji

### Krok 4 — Otwórz aplikację

1. Otwórz `INWENTARYZACJA.html` w przeglądarce Chrome lub Firefox
2. W górnym pasku zmień adres na IP serwera (np. `http://192.168.1.100:8090`)
3. Kliknij **„Połącz"** — powinno pojawić się zielone ✅

---

## Dla kotków w sieci (tablety, telefony, inne komputery)
<img width="1643" height="790" alt="image" src="https://github.com/user-attachments/assets/3d3bd5fe-454a-4653-a576-b3e37336e15a" />

Na każdym urządzeniu w sieci szkolnej wystarczy otworzyć przeglądarkę i wpisać:

```
http://[IP_SERWERA]:8090
```

Gdzie IP_SERWERA to adres wyświetlony przez `START_SERWER.ps1`.

Możesz też skopiować plik `INWENTARYZACJA.html` na każde urządzenie —  
wpisujesz adres serwera raz i jest zapamiętany.
<img width="804" height="781" alt="image" src="https://github.com/user-attachments/assets/fe511bbd-086e-4de5-9c64-c0d0a4e4b321" />
<img width="535" height="815" alt="image" src="https://github.com/user-attachments/assets/3a1ba2be-12b3-4c06-9eac-9ec3eaf8136d" />

---

## Co potrafi aplikacja?

| Funkcja | Opis |
|---|---|
| 📋 Lista sprzętu | Tabela (desktop) lub karty (mobile), sortowanie, filtry |
| ➕ Dodaj sprzęt | Formularz z oceną stanu, zaleceniem, uwagami |
| 📷 Skaner | Skanowanie kodów QR i kreskowych przez kamerę |
| 🖼️ Zdjęcia | Upload do 5 zdjęć na urządzenie, podgląd, lightbox |
| 🏷️ Etykiety | Etykiety do druku z QR kodem i (mini-)zdjęciem |
| 📊 Raport | Podsumowanie dla dyrektora, gotowe do druku |
| 🗑️ / 🔧 | Szybkie listy: do wyrzucenia / do naprawy |
| 📥 CSV | Eksport całej bazy do Excela |
| 🖥️/📱 | Tryb desktop (tabela) i mobile (karty) |

---
<img width="1373" height="184" alt="image" src="https://github.com/user-attachments/assets/1ca7bf00-da29-42db-9558-4f746d4a57b0" />
<img width="681" height="196" alt="image" src="https://github.com/user-attachments/assets/3621a978-197d-4449-a6b4-6765bb76c26c" />

## Backup danych

PocketBase przechowuje dane w folderze `pocketbase/pb_data/`.  
**Zrób kopię tego folderu** po inwentaryzacji — to cała baza danych!

Możesz też użyć panelu admina (`/_/`) → sekcja **Backups**.

---

## Rozwiązywanie problemów

**„Nie mogę się połączyć z innego urządzenia"**
- Sprawdź czy `START_SERWER.ps1` jest uruchomiony
- Sprawdź IP serwera w oknie PowerShell
- Sprawdź czy Windows Defender Firewall nie blokuje portu 8090
- Wszystkie urządzenia muszą być w tej samej sieci Wi-Fi/LAN

**„Błąd pobierania PocketBase"**
- Pobierz ręcznie z: https://github.com/pocketbase/pocketbase/releases
- Plik: `pocketbase_X.X.X_windows_amd64.zip`
- Wypakuj `pocketbase.exe` do folderu `pocketbase\`

**„Skrypt nie uruchamia się"**  
Otwórz PowerShell jako Administrator i wpisz:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

*Zbudowane z 🐱 przez Kociego Inżyniera*

 
 
