<#
Sidst opdateret d. 2 juni 2022.
Version: Pre-release
Udviklet af: Jesper 'Pazia' Sørensen
#>

<#
Roadmap
- Valg af tjenesteudbyder til statistik
- Skrivebeskytte log-filen for at undgå redigering af indholdet.
- Fejl indrapporteres via log-filen for fejlsøgning og forbedring af programmet.
- Velkommen/afslutning af scriptet
- Bed om tilladelse til at uploade oprettet filer til FTP/HTTP-server
- Flyt log-filerne fra %temp%-mappen, så brugeren har mulighed for at åbne dem
- Set-Location for at minimere variabler i scriptet

$ispList = 'YouSee', 'Telenor', 'Fibia', 'Senia Network', 'BOLIG:NET', 'TDC Erhverv', 'Hiper', 'Fastspeed', 'Stofa', 'Boxer', 'IP Vision', 'Altibox', 'Cibicom', 'Kviknet'

Større updates til scriptet
- Globalconnect tilføjet.
- Endelig vises resultater fra iPerf korrekt. RegEx fejl rettet.
- Opdateret iPerf version - https://files.budman.pw/iperf3.11_64bit.zip
#>

$ProgressPreference = 'SilentlyContinue' # Suppress progress.

# TimeStamp for logfile
function Get-TimeStamp {
  return "{0:dd/MM/yy} {0:HH:mm:ss}" -f (Get-Date)
}

Write-Host "`nVariabler indlæst.. " -NoNewline
Write-Host "[" -NoNewline
Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
Write-Host "]"

# Create files needed
$kviknet = (Get-Date -Format "dd-MM-yyyy_HH-mm-ss") + " " + "kviknet.txt"
$deic = (Get-Date -Format "dd-MM-yyyy_HH-mm-ss") + " " + "deic.txt"
$fiberby = (Get-Date -Format "dd-MM-yyyy_HH-mm-ss") + " " + "fiberby.txt"
$globalconnect = (Get-Date -Format "dd-MM-yyyy_HH-mm-ss") + " " + "globalconnect.txt"
$log = (Get-Date -Format "dd-MM-yyyy_HH-mm-ss") + " " + "log.txt"

New-Item -Path $env:TEMP -Name kviknet.txt -ItemType File > $null
New-Item -Path $env:TEMP -Name deic.txt -ItemType File > $null
New-Item -Path $env:TEMP -Name fiberby.txt -ItemType File > $null
New-Item -Path $env:TEMP -Name globalconnect.txt -ItemType File > $null
New-Item -Path $env:TEMP -Name log.txt -ItemType File > $null

Start-Sleep -Seconds 1

Rename-Item -Path $env:TEMP\kviknet.txt -NewName $kviknet > $null
Rename-Item -Path $env:TEMP\deic.txt -NewName $deic > $null
Rename-Item -Path $env:TEMP\fiberby.txt -NewName $fiberby > $null
Rename-Item -Path $env:TEMP\globalconnect.txt -NewName $globalconnect > $null
# Rename-Item -Path $env:TEMP\norlys.txt -NewName $norlys > $null
Rename-Item -Path $env:TEMP\log.txt -NewName $log > $null

Write-Host "Log filer oprettet og klar til brug.. " -NoNewline
Write-Host "[" -NoNewline
Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
Write-Host "]"

# End of log file creation and variable used within the script.

# This section has been reserved for welcome-message to the user upon loading the script.

# End of welcome message

# Check for iPerf3.exe
if ((Test-Path $env:TEMP\iperf3.exe -PathType Leaf) -and (Test-Path $env:TEMP\cyg*.dll -PathType Leaf) ) {
    Write-Host "iPerf3.exe lokaliseret.. " -NoNewline
    Write-Host "[" -NoNewline
    Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
    Write-Host "]"
}
  else {
    Write-Host "iPerf blev ikke fundet. Downloader.. " -NoNewline

    Invoke-WebRequest -Uri "https://files.budman.pw/iperf3.11_64bit.zip" -OutFile "$env:TEMP\iperf3.zip" > $null
    Expand-Archive -Path "$env:TEMP\iperf3.zip" -DestinationPath $env:TEMP -Force > $null

    Move-Item -Path $env:TEMP\iperf3.11_64bit\*.* -Destination $env:TEMP -Force > $null
    
    Remove-Item -Path $env:TEMP\iperf3.11_64bit -Force > $null
    Remove-Item -Path $env:TEMP\iperf3.zip -Force > $null

    Write-Host "[" -NoNewline
    Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
    Write-Host "]"
}

# Warning if 1 Gbps uplink isn't detected
Get-NetAdapter -Name "*" -Physical | ForEach-Object {  
    if ($_.LinkSpeed -match "10 Mbps" -and "100 Mbps") { 
      Write-Warning "Netværkskort opererer ikke med 1 Gbps / 10 Gbps uplink som forventet. Scriptet afbrydes..`nTjek venligst dine netværkskabler og opsætning."
      Break
    }
    else {
      Write-Host "Kontrollerer netværkskort.. " -NoNewline
      Write-Host "[" -NoNewline
      Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
      Write-Host "]"
    }
}

# iPerf variables for Invoke-Expressions

$kviknet_download = '& $env:TEMP\iperf3.exe -c ookla.kviknet.dk -t 15 -P 10 -R --logfile $env:TEMP\$kviknet'
$kviknet_upload = '& $env:TEMP\iperf3.exe -c ookla.kviknet.dk -t 15 -P 10 --logfile $env:TEMP\$kviknet'

$deic_dowload = '& $env:TEMP\iperf3.exe -c iperf.deic.dk -t 15 -P 10 -R --logfile $env:TEMP\$deic'
$deic_upload = '& $env:TEMP\iperf3.exe -c iperf.deic.dk -t 15 -P 10 --logfile $env:TEMP\$deic'

$fiberby_dowload = '& $env:TEMP\iperf3.exe -c speed.fiberby.dk -t 15 -P 10 -R --logfile $env:TEMP\$fiberby'
$fiberby_upload = '& $env:TEMP\iperf3.exe -c speed.fiberby.dk -t 15 -P 10 --logfile $env:TEMP\$fiberby'

$globalconnect_dowload = '& $env:TEMP\iperf3.exe -c iperf.globalconnect.dk -t 15 -P 10 -R --logfile $env:TEMP\$globalconnect'
$globalconnect_upload = '& $env:TEMP\iperf3.exe -c iperf.globalconnect.dk -t 15 -P 10 --logfile $env:TEMP\$globalconnect'

# Speed measurement for iPerf

Write-Host "`nStarter iPerf.. "

Write-Host "`niPerf resultat via Kviknet:"
Invoke-Expression $kviknet_download

if(Select-String -path "$env:TEMP\$kviknet" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$kviknet" | Select-Object -Index 214) -replace '.+\b(\d.+\sMbits/sec).+', 'Download: $1'
}
  else {
    Write-Host "Download: Fejl!"
}

Invoke-Expression $kviknet_upload

  if(Select-String -path "$env:TEMP\$kviknet" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$kviknet" | Select-Object -Index 432) -replace '.+\b(\d.+\sMbits/sec).+', 'Upload: $1'
}
  else {
    Write-Host "Upload: Fejl!"
}

Write-Host "`niPerf resultat via DeiC:"
Invoke-Expression $deic_dowload

if(Select-String -path "$env:TEMP\$deic" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$deic" | Select-Object -Index 214) -replace '.+\b(\d.+\sMbits/sec).+', 'Download: $1'
}
  else {
    Write-Host "Download: Fejl!"
}

Invoke-Expression $deic_upload

if(Select-String -path "$env:TEMP\$deic" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$deic" | Select-Object -Index 432) -replace '.+\b(\d.+\sMbits/sec).+', 'Upload: $1'
}
  else {
    Write-Host "Upload: Fejl!"
}

Write-Host "`niPerf resultat via Fiberby:"
Invoke-Expression $fiberby_dowload

  if(Select-String -path "$env:TEMP\$fiberby" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$fiberby" | Select-Object -Index 214) -replace '.+\b(\d.+\sMbits/sec).+', 'Download: $1'
}
  else {
    Write-Host "Download: Fejl!"
}

Invoke-Expression $fiberby_upload

if(Select-String -path "$env:TEMP\$fiberby" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$fiberby" | Select-Object -Index 432) -replace '.+\b(\d.+\sMbits/sec).+', 'Upload: $1'
}
  else {
    Write-Host "Upload: Fejl!"
}

Write-Host "`niPerf resultat via Globalconnect:"
Invoke-Expression $globalconnect_dowload

  if(Select-String -path "$env:TEMP\$globalconnect" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$globalconnect" | Select-Object -Index 214) -replace '.+\b(\d.+\sMbits/sec).+', 'Download: $1'
}
  else {
    Write-Host "Download: Fejl!"
}

Invoke-Expression $globalconnect_upload

if(Select-String -path "$env:TEMP\$globalconnect" -pattern "iperf Done.")
{
    (Get-Content "$env:TEMP\$globalconnect" | Select-Object -Index 432) -replace '.+\b(\d.+\sMbits/sec).+', 'Upload: $1'
}
  else {
    Write-Host "Upload: Fejl!"
}

# iPerf speed measurements completed

# NIC informations
Write-Host "`nIndhenter oplysninger om netværkskortet.. " -NoNewline

Add-Content -Path "$env:TEMP\$log" -Encoding UTF8 -Value "Udført d. $(Get-TimeStamp)" -PassThru > $null
Get-NetAdapter -Name "*" | Format-Table Name, InterfaceDescription, VlanID, LinkSpeed, MediaConnectionState | Out-File -Encoding UTF8 -FilePath "$env:TEMP\$log" -Append

Start-Sleep -Seconds 1

Write-Host "[" -NoNewline
Write-Host "OK" -ForegroundColor DarkGreen -NoNewline
Write-Host "]"

# Move .txt files - STILL IN PROGRESS

# End of script
Write-Host "Scriptet er nu udført..`nFeedback kan rapporteres via github.com/pazia eller jesper@pazia.dk"

Break
