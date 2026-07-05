#!/usr/bin/env bash
# Сборка Windows .exe из gmapp.py через Wine + Windows-Python + PyInstaller.
# Требует установленного wine64. Запуск: bash build_exe.sh
set -e

SRC=/home/s/dev/goodman-desktop
WB=/tmp/claude-1000/-home-s/bb8c1c70-375d-462b-8e9b-8f8e8a2809be/scratchpad/winbuild
PKG=$WB/pkg
export WINEPREFIX=$HOME/.winegm
export WINEARCH=win64
export WINEDEBUG=-all
PYVER=3.12.8
PYEXE=python-$PYVER-amd64.exe

echo "== 1. init wine prefix =="
wineboot -i >/dev/null 2>&1 || true
sleep 2

echo "== 2. Windows Python =="
if [ ! -f "$WB/$PYEXE" ]; then
  wget -qO "$WB/$PYEXE" "https://www.python.org/ftp/python/$PYVER/$PYEXE"
fi
# тихая установка Windows-питона в wine-префикс
wine "$WB/$PYEXE" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 >/dev/null 2>&1 || true
sleep 3

# путь к python.exe внутри wine
WPY="$WINEPREFIX/drive_c/Program Files/Python312/python.exe"
[ -f "$WPY" ] || WPY="$WINEPREFIX/drive_c/users/$USER/AppData/Local/Programs/Python/Python312/python.exe"

echo "== 3. pip + pyinstaller =="
wine "$WPY" -m pip install --upgrade pip pyinstaller >/dev/null 2>&1

echo "== 4. сборка exe =="
BUILD=$WB/exebuild
rm -rf "$BUILD"; mkdir -p "$BUILD"
cp "$SRC/gmapp.py" "$SRC/gmcore.py" "$SRC/ui.html" "$SRC/logo.png" "$BUILD/"
cp "$PKG/sing-box.exe" "$PKG/wintun.dll" "$BUILD/"
cp "$SRC/win/logo.ico" "$BUILD/"
cd "$BUILD"

wine "$WPY" -m PyInstaller --onefile --noconsole --uac-admin --clean \
  --name GoodManNet \
  --icon logo.ico \
  --add-data "sing-box.exe;." \
  --add-data "wintun.dll;." \
  --add-data "ui.html;." \
  --add-data "logo.png;." \
  --hidden-import gmcore \
  gmapp.py

echo "== готово =="
ls -la "$BUILD/dist/GoodManNet.exe"
