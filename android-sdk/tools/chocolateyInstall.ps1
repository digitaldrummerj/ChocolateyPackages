. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')

Install-ChocolateyZipPackage -PackageName $packageName -url $downUrl -unzipLocation $destination -ChecksumType "$checksumType" -Checksum "$checksum"
 
Install-ChocolateyPath $envToolsPath  'Machine'
Install-ChocolateyPath $envPlatformsPath 'Machine'
Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' ${envPath} 'Machine'
refreshenv

echo yes | android update sdk --filter tools --filter platform-tools --all --no-ui
