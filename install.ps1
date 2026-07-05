# GoodMan Net — установщик для Windows. ПКМ по файлу → «Выполнить с помощью PowerShell».
# Ставит приложение в Program Files и создаёт ярлыки. VPN работает без отдельной службы:
# приложение запускается с правами администратора (UAC) и само держит sing-box.
$ErrorActionPreference = 'Stop'

# самоповышение прав
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
         ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Start-Process powershell "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$Src  = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Dst  = "$env:ProgramFiles\GoodManNet"
$Data = "$env:ProgramData\GoodManNet"

Write-Host "-> Копирую файлы в $Dst ..."
# на случай обновления — остановим работающий sing-box
taskkill /F /IM sing-box.exe 2>$null | Out-Null
New-Item -ItemType Directory -Force -Path $Dst  | Out-Null
New-Item -ItemType Directory -Force -Path $Data | Out-Null
Copy-Item "$Src\*" $Dst -Recurse -Force -Exclude 'install.ps1'

Write-Host "-> Открываю каталог конфига на запись пользователю ..."
$acl  = Get-Acl $Data
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Users","Modify","ContainerInherit,ObjectInherit","None","Allow")
$acl.AddAccessRule($rule); Set-Acl $Data $acl

Write-Host "-> Создаю ярлыки ..."
$ws = New-Object -ComObject WScript.Shell
foreach ($p in @("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\GoodMan Net.lnk",
                 "$env:PUBLIC\Desktop\GoodMan Net.lnk")) {
    $lnk = $ws.CreateShortcut($p)
    $lnk.TargetPath = "$Dst\launcher.bat"
    $lnk.WorkingDirectory = $Dst
    $lnk.IconLocation = "$Dst\logo.ico"
    $lnk.Save()
}

Write-Host ""
Write-Host "OK. Установлено." -ForegroundColor Green
Write-Host "Запуск — ярлык 'GoodMan Net' (рабочий стол / меню Пуск)."
Write-Host "При старте подтвердите запрос UAC — он нужен для создания VPN-адаптера."
Write-Host "Затем вставьте ссылку на подписку и нажмите большую кнопку."
