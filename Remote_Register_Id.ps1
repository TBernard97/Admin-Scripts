$file = Read-Host -Prompt "Input Target List Path"
$computers = Get-Content -Path $file 
$1909 = Read-Host -Prompt "Input File Name for 1909"
$1903 = Read-Host -Prompt "Input File Name for 1903"
$1809 = Read-Host -Prompt "Input File Name for 1809"
$1803 = Read-Host -Prompt "Input File Name for 1803"
$1709 = Read-Host -Prompt "Input File Name for 1709"
$1703 = Read-Host -Prompt "Input File Name for 1703"
$1607 = Read-Host -Prompt "Input File Name for 1607"
$Other = Read-Host -Prompt "Input File Name for Other Register ID's"
$Offline = Read-Host -Prompt "Input File Name for Offline Nodes"

$ErrorActionPreference = 'silentlycontinue'

foreach($computer in $computers){
    if(Test-Connection -computername $computer -Quiet){
        $Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $KeyPath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        $Value = 'ReleaseId'
        $os = Get-WmiObject Win32_OperatingSystem -Computer $computer
        $osversion = $os.version 
        
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $computer)
        $key = $reg.OpenSubKey($KeyPath)
        
        $keystring = $key.GetValue($Value)
        
        if($osversion -eq '6.1.7601'){
           Write-Output("$computer -> Win 7") 
        } else{
            Write-Output("$computer -> $keystring")
        }
        
        
        if($keystring -match "1803"){
            Write-Output($computer) | Out-File -Append $1803
        }
        elseif($keystring -match "1703"){
            Write-Output($computer) | Out-File -Append $1703
        }
        elseif($keystring -match "1709"){
            Write-Output($computer) | Out-File -Append $1709
        }
        elseif($keystring -match "1809"){
            Write-Output($computer) | Out-File -Append $1809
        }
        elseif($keystring -match "1607"){
            Write-Output($computer) | Out-File -Append $1607
        }
        elseif($osversion -eq '6.1.7601'){
            Write-Output($computer) | Out-File -Append $Other
        }
        
        elseif($keystring -match "1903"){
            Write-Output($computer) | Out-File -Append $1903
        } 

        elseif($keystring -match "1909"){
            Write-Output($computer) | Out-File -Append $1909
        }
        
    }

    else{
        Write-Output("$computer -> offline") | Out-File -Append $Offline
    }
}
