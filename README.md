# GoodMan Net — Windows

Десктоп-клиент VPN **GoodMan Net** для Windows. Приложение на Python (`gmapp.py`) с нативным
интерфейсом (tkinter) поверх [sing-box](https://github.com/SagerNet/sing-box); туннель поднимается
через wintun. Подписку из личного кабинета вставляете один раз — дальше одна большая кнопка.

Та же кодовая база используется для Linux и macOS (см. репозитории `goodman-net-linux`, `goodman-net-macOS`).

## Файлы

```
gmapp.py        приложение (UI + управление туннелем)
gmcore.py       разбор подписки, генерация конфигурации sing-box, замер скорости
ui.html         web-режим (fallback)
flags/          флаги стран, logo.png / logo.ico — иконки
build_exe.sh    сборка .exe (Wine + PyInstaller, onefile)
install.ps1     установка на Windows
launcher.bat    запуск
```

## Сборка .exe

Собирается в Linux через Wine + PyInstaller:
```
./build_exe.sh
```
Готовый подписанный установщик и контрольные суммы — на [gdman.ink](https://gdman.ink), раздел «Инструкция».

## Безопасность

Никаких ключей/токенов в коде нет — подписка вводится пользователем. Клиент общается только с
VPN-серверами GoodMan Net. sing-box — под GPLv3.
