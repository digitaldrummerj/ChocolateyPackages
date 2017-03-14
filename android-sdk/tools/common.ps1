$packageName = 'android-sdk'

$downUrl = 'https://dl.google.com/android/repository/tools_r25.2.3-windows.zip'
$checksum = '23d5686ffe489e5a1af95253b153ce9d6f933e5dbabe14c494631234697a0e08'
$checksumType = 'sha256'

$androidPath = "${Env:SystemDrive}\Android"
$destination = "${androidPath}\android-sdk"

$fileName = 'tools_r25.2.3-windows.zip'

$envPath = "${destination}"
$envToolsPath = "${envPath}\tools"
$envPlatformsPath = "${envPath}\platform-tools"

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