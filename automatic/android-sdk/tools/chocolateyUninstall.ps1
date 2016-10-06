  
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


Uninstall-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\tools" 'User'
Uninstall-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\platform-tools" 'User'

$packageName = 'android-sdk'

$unpath = "${Env:LOCALAPPDATA}\Android\android-sdk\uninstall.exe"
if (Test-Path ($unpath)) {
    Uninstall-ChocolateyPackage $packageName 'exe' '/S' $unpath
}    