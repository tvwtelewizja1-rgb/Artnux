# Artnux Live 0.4 — pierwsze efekty i projekt prawdziwego ISO

**To repozytorium źródeł, nie gotowy obraz .iso.** Wcześniejsze Artnux 0.1/0.2 nie startowały w VirtualBoxie, więc nie należy ich instalować.

## Co zobaczysz od razu

- **Artnux-Aero-0.4-PODGLAD.png** — sprawdzony zrzut pierwszego pulpitu.
- **Artnux-Aero-0.4-PODGLAD.html** — interaktywna wizualizacja Aero. Otwórz dwuklikiem w przeglądarce; nie wymaga niczego instalować.
- Podgląd to projekt wyglądu, nie dystrybucja systemu. Działają menu, okna i konfiguracja wyglądu w przeglądarce.

## Jak otrzymać PRAWDZIWE ISO Artnuxa (bez lokalnego linuksowego terminala)

1. Na GitHubie utwórz **nowe repozytorium Artnux**.
2. Wgraj CAŁĄ zawartość tego katalogu (włącznie z ukrytym `.github`). Uwaga: strona GitHub `Upload files` nie zawsze ułatwia przekazanie katalogów; można użyć GitHub Desktop.
3. W repozytorium przejdź **Actions > Build Artnux Live 0.4 > Run workflow**.
4. Kompilacja odbywa się na serwerze w kontenerze `debian:trixie`, z oficjalnym `live-build`, Debianem 13, KWin/KDE, Calamares, Wine i aplikacjami graficznymi.
5. Workflow **publikuje ISO dopiero po pomyślnym teście QEMU BIOS** i sprawdzeniu katalogu rozruchowego BIOS+UEFI; szukaj w sekcji **Artifacts** pliku `Artnux-Live-0.4-ISO`.
6. Jeśli budowanie nie przejdzie, zamiast udawać sukces pobierz `Artnux-0.4-LOGI`. Nie ma wtedy zweryfikowanego ISO.
7. Podłącz powstały ISO w VirtualBoxie. Na początku **nie formatuj prawdziwego SSD**.

## Ograniczenia (uczciwie)

- W tym czacie brak dostępu do pakietów Debiana i emulatora QEMU, stąd nie było możliwości zbudowania tu gotowego, sprawdzonego ISO.
- Konfiguracja live-build i workflow zostały sprawdzone składniowo; pełna kompilacja w GitHub Actions musi zostać wykonana, by potwierdzić, że skrypty rzeczywiście budują poprawny obraz.
- Test QEMU obejmuje BIOS i start jądra, ale nie potwierdza jeszcze kompletnego pulpitu ani instalatora.
- BIOS i UEFI są zadeklarowane w konfiguracji live-build; osobny test uruchamiania UEFI w tej wersji nie jest jeszcze wykonany.
- Na razie to KDE Plasma z motywem/efektami Artnux. Pełny autorski desktop, animacje Vista, Neutron i działające Adobe to **dalsze prace**, nie istniejące dziś funkcje.
- Wine może uruchamiać niektóre EXE, ale nie gwarantuje pracy After Effects lub Premiere.
- Użyj testowej VM, a nie SSD bez kopii zapasowej. Instalacja przez Calamares zmienia partycje.

## Linux / Debian 13 lokalnie

```bash
sudo bash scripts/install-build-tools.sh
sudo bash build-artnux.sh
```

Wynik (po udanym buildzie): `dist/Artnux-Live-0.4-amd64.iso`.

Źródła: https://live-team.pages.debian.net/live-manual/html/live-manual.en.html ; https://manpages.debian.org/trixie/live-build/lb_config.1.en.html
