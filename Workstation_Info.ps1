<#  PROGRAM DRAFT FOR QUERYING CRITCAL INFORMATION FOR WORKSTATION OFFICE MACHINES ON INFRASTRUCTURE
#>

$targets = Read-Host ('Please input target filepath')
$failed = Read-Host('Please input filepath name for failed requests')
$success = Read-Host ('Please input filepath name for successful request')

foreach($target in Get-Content $targets){
    if(test-connection $target -Quiet){
        
        #Operating System and Architecture
        $os = Get-WmiObject Win32_OperatingSystem -Computer $target
        $architecture = Get-WmiObject Win32_Processor -Computer $target
        $osversion = $os.version
        $bitallocation = $architecture.caption

        #Register ID for Windows 10
        $Hive = [Microsoft.Win32.RegistryHive]::LocalMachine    

        if($osversion -eq '6.1.7601'){
            
            $RegKeyString = '[!] Windows 7'
        }
        
        else {
            
            $RegPath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
            $RegisterID = 'ReleaseId'
            $RegIDPrimaryKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $target)
            $RegSubKey = $RegIDPrimaryKey.OpenSubKey($RegPath)
            $RegKeyString = $RegSubKey.GetValue($RegisterID)
    
        }   
        
        #.NET
        $NETPath = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
        $NETVersion = 'Version'
        $NETPrimaryKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $target)
        $NETSubKey = $NETPrimaryKey.OpenSubKey($NETPath)
        $NETVersionKeyString = $NETSubKey.GetValue($NETVersion)
      
     
        #Java
        $JavaPath = 'SOFTWARE\JavaSoft\Java Runtime Environment\'
        $JavaVersion = 'BrowserJavaVersion'
        $JavaPrimaryKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $target)
        $JavaSubkey = $JavaPrimaryKey.OpenSubKey($JavaPath)
        $JavaVersionKeyString = $JavaSubkey.GetValue($JavaVersion) 

        if(!$JavaVersionKeyString){
            SilentlyContinue
        }
        
    

       Write-Output("[INFO] MACHINE : $Target => Operating System : $osversion , Architecture: $bitallocation , RegisterID : $RegKeyString , .NETVersions : $NETVersionKeyString  , Java Versions : $JavaVersionKeyString ") -ErrorAction SilentlyContinue
       Write-Output("[INFO] MACHINE : $Target => Operating System : $osversion , Architecture: $bitallocation , RegisterID : $RegKeyString , .NETVersions : $NETVersionKeyString  , Java Versions : $JavaVersionKeyString ") -ErrorAction SilentlyContinue | Out-File -Append $success
        
       
    }

    
    
    
    else {
        Write-Output ("[ERROR] $target IS OFFLINE")
        Write-Output ("[ERROR] $target IS OFFLINE") | Out-File -Append $failed
    }
    
    

    
}