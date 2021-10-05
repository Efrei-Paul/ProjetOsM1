<#
Composants redondants
#>
$compname = (Get-CimInstance -ClassName Win32_ComputerSystem).name
$Date = Get-Date


<#
1. General : Nom Hardware OS IP Mac ...
#>
$name = "<h1>Computer name: $compname</h1>"

$os = Get-CimInstance Win32_OperatingSystem | ConvertTo-Html -As List -Property status,version,name,Manufacturer,InstallDate,LastBootUpTime -Fragment -PreContent "<h2>Operating System</h2>"
$ip = Get-NetIPAddress | ConvertTo-Html -Property IPAddress -Fragment
$mac =  Get-NetAdapter | ConvertTo-Html -Property DeviceId -Fragment
$hardware = Get-CimInstance CIM_ComputerSystem | ConvertTo-Html -As List -Property Model -Fragment -PreContent "<h2>Hardware</h2>"

$General = ConvertTo-HTML -Body "$name $os $bar $ip $bar $mac $bar $hardware $bar $user" -Title "General" -Head $header

<#
Utilisateurs:
-Nom
-dernière connection
-Description
-Privilèges
#>

$user = Get-LocalUser | Select * | ConvertTo-Html -As Table -Property FullName,Description,Enabled,LastLogon -Fragment -PreContent "<h2>Users :</h2>"

<#
Afficher les paramètres de la vie privée, par exemple : Wifi sense (si version
Windowsinférieure à 1709), SmartScreen Filter dans Edge, suggestions du menu de
démarrage,Feedback, publicités (Advertising ID), localisation, Cortana, mise à jour windows peer-
to peer (Windows Update P2P), traçage (Diagnostics Tracking Service), accès camera
et microphone, …etc.
#>

$Webcam = Get-PnpDevice -Class "Webcam" | select * | ConvertTo-Html -As Table -Fragment -PreContent "<h3>Webcam :</h3>"


$Private = ConvertTo-HTML -Body "$webcam" -Title "General" -Head $header

<#
Affichage des services à arrêter en application du principe de minimisation.
#>

$Services = Get-Process | where {$_.priorityclass -eq 'AboveNormal' -OR $_.priorityclass -eq 'high'} | ConvertTo-Html -As Table -Property Id,Name,priorityclass -Fragment -PreContent "<h2>Process To stop :</h2>"

<#Durcissement#>
<#
Durcissement de la couche réseau, protocole TLS et paramètres de cryptographie.
#>


<#HTML#>
$bar = "<hr class='separator separator--line' />"

$header = @"
<style>

    h1 {

        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;

    }


    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;

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

$Report = ConvertTo-HTML -Body "$General $Users $Private $Services" -Title "Report - $Date" -Head $header
$Report | Out-File C:\Users\clemg\Report.html
