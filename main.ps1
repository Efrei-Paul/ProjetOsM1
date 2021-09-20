#<Audit>

<#
Affichage des informations générale sur la station : matériel, Bios, version OS, …
#>

$os = Get-CimInstance Win32_OperatingSystem
$hardware = Get-CimInstance CIM_ComputerSystem
$vm = get-wmiobject -computer LocalHost win32_computersystem
$name = (Get-CimInstance -ClassName Win32_ComputerSystem).Name

Write-Host "Hostname : $($name)"
Write-Host "staus : $($os.status)"
Write-Host ”OS Version: $($os.version)"
Write-Host "OSCaption : $($os.architecture)"
Write-Host "OS architecture : $($os.name)"
Write-Host "IP Address $((Get-NetIPAddress).IPAddress)"
Write-Host "Mac Address : $((Get-NetAdapter).DeviceId)"
Write-Host "VM : $($vm.IsVirtual)"
Write-Host "Model : $($hardware.Model)"
Write-Host "Manufacturer : $($os.Manufacturer)"
Write-Host "DateBuild : $($os.InstallDate)"
Write-Host "Last boot : $($os.LastBootUpTime)"


<#
Affichage des informations sur les comptes locaux (privilèges attribués à chaque
utilisateur, date de la dernière connexion, …etc) et vérification des paramètres des comptes.
#>

Get-LocalUser | Select *

<#
Afficher les paramètres de la vie privée, par exemple : Wifi sense (si version
Windowsinférieure à 1709), SmartScreen Filter dans Edge, suggestions du menu de
démarrage,Feedback, publicités (Advertising ID), localisation, Cortana, mise à jour windows peer-
to peer (Windows Update P2P), traçage (Diagnostics Tracking Service), accès camera
et microphone, …etc.
#>

<#
Affichage des services à arrêter en application du principe de minimisation.
#>

<#Durcissement#>
<#
Durcissement de la couche réseau, protocole TLS et paramètres de cryptographie.
#>
s
