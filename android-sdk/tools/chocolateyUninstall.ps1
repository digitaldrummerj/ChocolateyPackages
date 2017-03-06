  
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

$destination = "${Env:ProgramFiles}\Android\android-sdk"


Uninstall-ChocolateyPath "${destination}\tools" 'Machine'
Uninstall-ChocolateyPath "${destination}\platform-tools" 'Machine'
Uninstall-ChocolateyEnvironmentVariable -VariableName 'ANDROID_HOME' -VariableType 'Machine'

$packageName = 'android-sdk'

if (Test-Path ($destination)) {
    Uninstall-ChocolateyZipPackage $packageName 'tools_r25.2.3-windows.zip'
    Remove-Item $destination

    $directoryInfo = Get-ChildItem "${Env:ProgramFiles}\Android" | Measure-Object
    $directoryInfo.count #Returns the count of all of the files in the directory
    if ($directoryInfo.count -eq 0) {
      Remove-Item "${Env:ProgramFiles}\Android"
    }
}    
