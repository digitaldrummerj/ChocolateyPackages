$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common

# Function to remove a value from the Machine Environment Variable path value
function Uninstall-ChocolateyPath {
param(
  [string] $pathToUninstall,
  [System.EnvironmentVariableTarget] $pathType = [System.EnvironmentVariableTarget]::User
)
  Write-Debug "Running 'Uninstall-ChocolateyPath' with pathToUninstall:`'$pathToUninstall`'";
  
  #get the PATH variable
  $envPath = $env:PATH
  if ($envPath.ToLower().Contains($pathToUninstall.ToLower()))
  {
    Write-Host "Starting PATH environment variable update to remove $pathToUninstall"
    $actualPath = [Environment]::GetEnvironmentVariable('Path', $pathType)

    $statementTerminator = ";"
    $actualPath = (($actualPath -split $statementTerminator) -ne $pathToUninstall) -join $statementTerminator

    if ($pathType -eq [System.EnvironmentVariableTarget]::Machine) {
      $psArgs = "[Environment]::SetEnvironmentVariable('Path',`'$actualPath`', `'$pathType`')"
      Start-ChocolateyProcessAsAdmin "$psArgs"
    } else {
      [Environment]::SetEnvironmentVariable('Path', $actualPath, $pathType)
    }    
    
    $env:Path = $actualPath
	
	Write-Host "Completed PATH environment variable update to remove $pathToUninstall"
  }
}

# Helper function to figure out the GUID to use with msiexec to uninstall JDK and JRE versions that are installed for this package
# The GUID changes depending on if OS is x64 or i386
function Uninstall-JDK-And-JRE {
    $use64bit = use64bit
    if ($use64bit) {
        # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{64A3A4F4-B792-11D6-A78A-00B0D0170720}
        $jdk = " /qn /x {64A3A4F4-B792-11D6-A78A-00B0D0" + $uninstall_id + "0}"       
        # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F06417072FF}
        $jre = " /qn /x {26A24AE4-039D-4CA4-87B4-2F064" + $uninstall_id + "FF}"   
    } else {
        $jdk = " /qn /x {32A3A4F4-B792-11D6-A78A-00B0D0" + $uninstall_id + "0}"
        $jre = " /qn /x {26A24AE4-039D-4CA4-87B4-2F832" + $uninstall_id + "FF}"   
    }
     Write-Host "Uninstalling JDK"
     Start-ChocolateyProcessAsAdmin $jdk 'msiexec'
     Write-Host "Completed Uninstalling JDK"
     
     Write-Host "Uninstalling JRE"
     Start-ChocolateyProcessAsAdmin $jre 'msiexec'
     Write-Host "Completed Uninstalling JRE"
}

try {  

  # Uninstall JRE and JDK
  Uninstall-JDK-And-JRE

  # Remove java-bin from the Environment path
  $java_bin = get-java-bin  
  Uninstall-ChocolateyPath $java_bin 'Machine'
  
  # If CLASSPATH environment variable exist, make it null
  if ([Environment]::GetEnvironmentVariable('CLASSPATH','Machine') -eq '.;') {
        Write-Host "Uninstalled Machine Environment Variable 'CLASSPATH'"
        Install-ChocolateyEnvironmentVariable 'CLASSPATH' $null 'Machine'
  }
  
  # If JAVA_HOME environment variable equal to this version of the JDK, make it null
  if ([Environment]::GetEnvironmentVariable('JAVA_HOME','Machine') -eq "$java_home") {
	Write-Host "Making Machine Environment Variable 'JAVA_HOME' blank"
	Install-ChocolateyEnvironmentVariable 'JAVA_HOME' $null 'Machine'
	Write-Host "Completed Making Machine Environment Variable 'JAVA_HOME' blank"
  }
  
} catch {
      if ($_.Exception.InnerException) {
        $msg = $_.Exception.InnerException.Message
    } else {
        $msg = $_.Exception.Message
    }
    
    Write-ChocolateyFailure $package "$msg"
    throw 
}