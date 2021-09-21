<#
Composants redondants
#>
$compname = (Get-CimInstance -ClassName Win32_ComputerSystem).name
$Date = Get-Date
$bar = "<hr class='separator separator--line' />"
$name = "<h1>Computer name: $compname</h1>"

$GeneralHeader = "<h2>Général :</h2>"

<#
1. General : Nom Hardware OS IP Mac ...
#>
$os = Get-CimInstance Win32_OperatingSystem | ConvertTo-Html -Property status,version,name,Manufacturer,InstallDate,LastBootUpTime -Fragment -PreContent "<h3>Operating System :</h3>"
$ip = Get-NetIPAddress | ConvertTo-Html -Property IPAddress,ADDRESSFAMILY,Type -Fragment -PreContent "<h3>IP :</h3>"
$mac =  Get-NetAdapter | ConvertTo-Html -Property DeviceId,Status -Fragment -PreContent "<h3>MAC :</h3>"
$hardware = Get-CimInstance CIM_ComputerSystem | ConvertTo-Html -Property Model,Status,Name,DNSHOSTNAME,SYSTEMFAMILY,SYSTEMTYPE -Fragment -PreContent "<h3>Hardware :</h3>"
$General = ConvertTo-HTML -Body "$GeneralHeader $bar $os $bar $ip $bar $mac $bar $hardware $bar"
<#
Utilisateurs:
-Nom
-dernière connection
-Description
-Privilèges
#>

$Users = Get-LocalUser | Select * | ConvertTo-Html -As Table -Property FullName,Description,Enabled,LastLogon -Fragment -PreContent "<h2>Users :</h2>"

<#
Afficher les paramètres de la vie privée, par exemple : Wifi sense (si version
Windowsinférieure à 1709), SmartScreen Filter dans Edge, suggestions du menu de
démarrage,Feedback, publicités (Advertising ID), localisation, Cortana, mise à jour windows peer-
to peer (Windows Update P2P), traçage (Diagnostics Tracking Service), accès camera
et microphone, …etc.
#>

$Webcam = Get-PnpDevice -Class "Webcam" | select * | ConvertTo-Html -As Table -Fragment -PreContent "<h3>Webcam :</h3>"

$Private = ConvertTo-HTML -Body "$Webcam"

<#
Affichage des services à arrêter en application du principe de minimisation.
#>

<#Durcissement#>
<#
Durcissement de la couche réseau, protocole TLS et paramètres de cryptographie.
#>

<#Css#>

$header = @"
<style>
    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 22px;
    }
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;
    }
    h3 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        text-decoration: underline;     
        font-size: 14px;
    }
   table {
		font-size: 12px;
		border: 0px;
		font-family: Arial, Helvetica, sans-serif;
	}
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
        #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
    }
    $separator-size: 5px;
    $separator-border-style: solid;
    $separator-border-color: #bada55;
    $separator-space-top: 25px;
    $separator-space-bottom: 80px;
    .separator {
        margin-top: $separator-space-top;
        margin-bottom: $separator-space-bottom;
        border: 0;
        }
        .separator--line {
        border: 0;
        border-bottom: $separator-size $separator-border-style $separator-border-color;
        width: 0;
        animation: separator-width 1s ease-out forwards;
        }
        @keyframes separator-width {
        0% {
            width: 0;
        }
        100% {
            width: 100%;
        }
    }
    @keyframes dot-move-right {
    0% {
        left: 0;
    }
    100% {
        left: 32px;
    }
    }
    @keyframes dot-move-left {
    0% {
        left: 0;
    }
    100% {
        left: -32px;
    }
    }
</style>
"@

<#Html et sauvegarde#>
$Report = ConvertTo-HTML -Body "$name $General $Users $Private" -Title "Report - $Date" -Head $header
$Report | Out-File C:\Users\user\Report.html
