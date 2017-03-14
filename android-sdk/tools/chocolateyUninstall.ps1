. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')


if (Test-Path ($destination)) {
  Uninstall-ChocolateyZipPackage $packageName $fileName
  Uninstall-ChocolateyPath $envToolsPath 'Machine'
  Uninstall-ChocolateyPath $envPlatformsPath 'Machine'
  Uninstall-ChocolateyEnvironmentVariable -VariableName 'ANDROID_HOME' -VariableType 'Machine'

  Remove-Item $destination -Force -Recurse

  $directoryInfo = Get-ChildItem $androidPath | Measure-Object
  if ($directoryInfo.count -eq 0) {
    Remove-Item $androidPath 
  }
}    
