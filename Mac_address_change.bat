:: Change MAC script by bobdynlan, release 1
:: For each network adapter it will list RegPath, GUID, Name, previous modified MAC if exists
:: Then you can input new MAC, clear previous MAC by inputting 0 or skip by pressing [Enter]
:: You can paste directly from ipconfig or wireshark because : < > { } [ ] - ( ) . will be filtered out
:: Note that for wireless in Win7 standard drivers has to start with 02... 06... 0A... 0E...
@ECHO OFF &SET /A RLINE=1 &SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
FOR /F "tokens=3*" %%I IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /S^|FINDSTR /I /L "REG_SZ"') DO (
SET /A RLINE+=1 &SET /A PARITY=!RLINE!^%%2
IF !PARITY! EQU 0 (SET "ADAPTERGUID=%%I") ELSE (
SET "ADAPTERNAME=%%I %%J"
FOR /F %%A IN ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" /F "!ADAPTERGUID!" /D /E /S ^|FINDSTR /I /L /V "Linkage"^|FINDSTR /I /L "\\Class\\"') DO SET "REGPATH=%%A"
CLS &echo       Change MAC script by bobdynlan, release 1 &echo. &echo     RegPath = !REGPATH!  &echo     GUID = !ADAPTERGUID!  &echo     Adapter name = !ADAPTERNAME!
REG QUERY "!REGPATH!" /V "NetworkAddress" 2>&1 |FINDSTR /I /L "NetworkAddress"
SET "CHANGEMAC=" &SET "RESETMAC="
echo. &echo  Enter MAC address for this adapter [0 to reset it] or press [Enter] to skip: &SET /P "CHANGEMAC="
IF "!CHANGEMAC!"=="0" (SET "RESETMAC=Y" &SET "CHANGEMAC=") ELSE SET "RESETMAC="
IF DEFINED CHANGEMAC SET "CHANGEMAC=!CHANGEMAC: =!" &FOR %%I IN (: ^< ^> { } [ ] - ^( ^) .) DO SET "CHANGEMAC=!CHANGEMAC:%%I=!"
IF DEFINED CHANGEMAC REG ADD "!REGPATH!" /F /V NetworkAddress /T REG_SZ /D !CHANGEMAC! >nul 2>&1
IF DEFINED RESETMAC REG DELETE "!REGPATH!" /F /V NetworkAddress >nul 2>&1
))
IF DEFINED CHANGEMAC FOR /F "tokens=2,4*" %%I IN ('netsh interface show interface^|FINDSTR /I /L "Enabled"') DO (
netsh interface set interface %%J DISABLED
netsh interface set interface %%J ENABLED
)

