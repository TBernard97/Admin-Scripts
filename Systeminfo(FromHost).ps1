$targets = Read-Host -Prompt "Input Target List Path"
$outfile = Read-Host -Prompt "Input Output File Name"
$offlines = Read-Host -Prompt "Input Offline File Name"
foreach($target in Get-Content $targets){
    if (test-connection -computername $target -Quiet){   
        Write-Output("======================NODE: $target ================================") | Out-File -Append $outfile
        get-wmiobject Win32_ComputerSystem -Computer $target | Out-File -append $outfile
        get-wmiobject Win32_BIOS -Computer $target | Out-File -append $outfile
        get-wmiobject Win32_OperatingSystem -Computer $target | Out-File -append $outfile
        get-wmiobject Win32_Processor -Computer $target | Out-File -append $outfile
        Get-WmiObject Win32_LogicalDisk -ComputerName $target -Filter drivetype=3 | Out-File -append $outfile
    }
    
    else{
        Write-Output("$target is offline") | Out-File -append $offlines
    }


}
