$downUrl = 'https://dl.google.com/android/installer_r24.4.1-windows.exe'
$checksum = '260132A1903CAC17276FE2A6B7D710E96B69EC1D79DE8BE21AD828C58B45B804'
$checksumType = 'sha256'
Install-ChocolateyPackage 'android-sdk' 'exe' '/S' $downUrl -validExitCodes @(0)   -Checksum "$checksum" -ChecksumType "$checksumType"
 
Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\tools" 'User'
Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\platform-tools" 'User'
Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' "${Env:LOCALAPPDATA}\Android\android-sdk" 'User'
