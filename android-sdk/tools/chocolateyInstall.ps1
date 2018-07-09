. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')

Install-ChocolateyZipPackage -PackageName $packageName -url $downUrl -unzipLocation $destination -ChecksumType "$checksumType" -Checksum "$checksum"
 
Install-ChocolateyPath $envToolsPath  'Machine'
Install-ChocolateyPath $envPlatformsPath 'Machine'
Install-ChocolateyPath $envToolsBinPath 'Machine'
Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' ${envPath} 'Machine'
New-Item $env:userprofile\.android\repositories.cfg -type file
refreshenv

echo yes | sdkmanager tools platform-tools