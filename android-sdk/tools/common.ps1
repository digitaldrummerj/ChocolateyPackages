$packageName = 'android-sdk'

$downUrl = 'https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip'
$checksum = '7e81d69c303e47a4f0e748a6352d85cd0c8fd90a5a95ae4e076b5e5f960d3c7a'
$checksumType = 'sha256'

$androidPath = "${Env:SystemDrive}\Android"
$destination = "${androidPath}\android-sdk"

$fileName = 'sdk-tools-windows-4333796.zip'

$envPath = "${destination}"
$envToolsPath = "${envPath}\tools"
$envToolsBinPath = "${envtoolsPath}\bin"
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