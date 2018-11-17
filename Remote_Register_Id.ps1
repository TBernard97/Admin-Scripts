$file = Read-Host -Prompt "Input Target List Path"
$computers = Get-Content -Path $file 
$1809 = Read-Host -Prompt "Input File Name for 1809"
$1803 = Read-Host -Prompt "Input File Name for 1803"
$1709 = Read-Host -Prompt "Input File Name for 1709"
$1703 = Read-Host -Prompt "Input File Name for 1703"
$1607 = Read-Host -Prompt "Input File Name for 1607"
$Other = Read-Host -Prompt "Input File Name for Other Register ID's"
$Offline = Read-Host -Prompt "Input File Name for Offline Nodes"


foreach($computer in $computers){
    if(Test-Connection -computername $computer -Quiet){
        $Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
        $KeyPath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        $Value = 'ReleaseId'
        
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $computer)
        $key = $reg.OpenSubKey($KeyPath)
        
        $keystring = $key.GetValue($Value)
        Write-Output("$computer -> $keystring")
        
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
        else{
            Write-Output($computer) | Out-File -Append $Other
        }
        
        
    }

    else{
        Write-Output("$computer -> offline") | Out-File -Append $Offline
    }
}
