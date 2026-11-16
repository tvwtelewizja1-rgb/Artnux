#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/build-work"
DIST="$ROOT/dist"
if [[ "$(id -u)" -ne 0 ]]; then
  echo 'Zalecane: sudo ./build-artnux.sh'; exit 1
fi
for program in lb debootstrap xorriso mksquashfs; do
  if ! command -v "$program" >/dev/null 2>&1; then
    echo "Brak wymaganej aplikacji: $program"; echo 'Zobacz README_PL.md'; exit 1
  fi
done
if [[ -e "$WORK" ]]; then
  echo "Katalog $WORK juz istnieje. Nie usuwam go automatycznie."
  echo 'Przenies go lub zmien nazwe przed ponowna kompilacja.'
  exit 1
fi
mkdir -p "$WORK" "$DIST"
cd "$WORK"
# live-build tworzy standardowy hybrydowy obraz BIOS+UEFI; bez własnego bootloadera.
lb config \
  --mode debian \
  --distribution trixie \
  --architecture amd64 \
  --binary-images iso-hybrid \
  --bootloaders 'syslinux grub-efi' \
  --debian-installer none \
  --archive-areas 'main contrib non-free non-free-firmware' \
  --iso-application 'Artnux Live 0.4 Preview' \
  --iso-publisher 'Artnux Community' \
  --iso-volume 'ARTNUX_LIVE_04' \
  --hostname 'artnux' \
  --bootappend-live 'boot=live components locales=pl_PL.UTF-8 keyboard-layouts=pl console=ttyS0,115200n8 console=tty0'
cp -a "$ROOT/config/." "$WORK/config/"
# Wyjście z live-build. Nie dotyka dysków instalacyjnych.
lb build 2>&1 | tee "$WORK/build.log"
ISO="$WORK/live-image-amd64.hybrid.iso"
if [[ ! -s "$ISO" ]]; then
  echo 'Brak poprawnego wyniku live-build';exit 1
fi
cp -- "$ISO" "$DIST/Artnux-Live-0.4-amd64.iso"
sha256sum "$DIST/Artnux-Live-0.4-amd64.iso" > "$DIST/Artnux-Live-0.4-amd64.iso.sha256"
"$ROOT/scripts/verify-image.sh" "$DIST/Artnux-Live-0.4-amd64.iso"
echo "GOTOWE: $DIST/Artnux-Live-0.4-amd64.iso"
