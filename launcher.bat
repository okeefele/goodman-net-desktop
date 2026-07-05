@echo off
REM GoodMan Net — запуск. VPN-туннелю (wintun) нужны права администратора,
REM поэтому один раз при старте поднимаем UAC, дальше приложение само управляет sing-box.
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"
start "" "%~dp0python\pythonw.exe" "%~dp0gmapp.py"
