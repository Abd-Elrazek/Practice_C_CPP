@echo off
netsh interface set interface "Wireless" disable
reg add HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0011 /v NetworkAddress /d 22E347EA5931 
netsh interface set interface "Wireless" enable
echo Ok, enjoy it :)
set /p delexit = press INTER Key to exit.... 