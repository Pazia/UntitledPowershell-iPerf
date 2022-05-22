Readme.txt for UntitledPowershell-iPerf
-------------------------------------------
Script last executed on the 22.05.2022 for initially test purposes.

Initialiserer.. Dette kan tage et øjeblik. [OK]
iPerf3.exe lokaliseret.. [OK]
Kontrollerer netværkskort.. [OK]
Påbegynder hastighedsmålinger.. Vent venligst.
Resultat via Kviknet:
Download: 310 Mbits/sec
Upload: 308 Mbits/sec

Resultat via DeiC:
Download: 299 Mbits/sec
Upload:: 309 Mbits/sec

Resultat via Fiberby:
Download: 307 Mbits/sec
Upload:: 309 Mbits/sec
Indhenter oplysninger om netværkskortet..
Remove-Item : Cannot find path 'C:\Users\Jesper\AppData\Local\Temp\iperf3.11_64bit' because it does not exist.
At C:\Users\Jesper\Desktop\norlys-tele.ps1:156 char:1
+ Remove-Item -Path $env:temp\iperf3.11_64bit -Force
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\Jesper...iperf3.11_64bit:String) [Remove-Item], ItemNotFoundEx
   ception
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.RemoveItemCommand

Remove-Item : Cannot find path 'C:\Users\Jesper\AppData\Local\Temp\iperf.zip' because it does not exist.
At C:\Users\Jesper\Desktop\norlys-tele.ps1:157 char:1
+ Remove-Item -Path $env:temp\iperf.zip -Force
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\Jesper...\Temp\iperf.zip:String) [Remove-Item], ItemNotFoundEx
   ception
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.RemoveItemCommand

Line 21 to 35 has been fixed. Remove-Item command moved into check-function for the iperf3.exe file before the script attemps to delete files/folders that doesn't exist.
