#<Audit>

<#
Affichage des informations générale sur la station : matériel, Bios, version OS, …
#>


$compname = (Get-CimInstance -ClassName Win32_ComputerSystem).name
$Date = Get-Date


$name = "<h1>Computer name: $compname</h1>"

$os = Get-CimInstance Win32_OperatingSystem | ConvertTo-Html -As List -Property status,version,name,Manufacturer,InstallDate,LastBootUpTime -Fragment -PreContent "<h2>Operating System</h2>"
$ip = Get-NetIPAddress | ConvertTo-Html -Property IPAddress -Fragment
$mac =  Get-NetAdapter | ConvertTo-Html -Property DeviceId -Fragment
$hardware = Get-CimInstance CIM_ComputerSystem | ConvertTo-Html -As List -Property Model -Fragment -PreContent "<h2>Hardware</h2>"

<#
Affichage des informations sur les comptes locaux (privilèges attribués à chaque
utilisateur, date de la dernière connexion, …etc) et vérification des paramètres des comptes.
#>

$user = Get-LocalUser | Select * | ConvertTo-Html -As Table -Property FullName,Description,Enabled,LastLogon -Fragment -PreContent "<h2>User</h2>"

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

$bar = @"
<div class="or-spacer">
  <div class="mask"></div>
  <span><i></i></span>
</div>
"@

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

    .or-spacer {
  margin-top:100px; margin-left:100px; width:400px;
  position:relative;

  .mask {
    overflow:hidden; height:20px;
    &:after {
      content:'';
      display:block; margin:-25px auto 0;
      width:100%; height:25px;
      border-radius:125px / 12px;
      box-shadow:0 0 8px black;
    }
  }
  span {
    $size:50px;
    width:$size; height:$size;
    position:absolute;
    bottom:100%; margin-bottom:-$size/2;
    left:50%; margin-left:-$size/2;
    border-radius:100%;
    box-shadow:0 2px 4px #999;
    background:white;
  }
  span i {
    $offset:4px;
    position:absolute;
    top:$offset; bottom:$offset;
    left:$offset; right:$offset;
    border-radius:100%;
    border:1px dashed #aaa;

    text-align:center;
    line-height:40px;
    font-style:normal;
    color:#999;
  }
}
</style>
"@

$Report = ConvertTo-HTML -Body "$name $os $bar $ip $bar $mac $bar $hardware $bar $user" -Title "Report - $Date" -Head $header
$Report | Out-File C:\Users\clemg\Report.html
