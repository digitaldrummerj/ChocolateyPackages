$downUrl = 'https://dl.google.com/android/installer_r24.4.1-windows.exe'
$checksum = '260132A1903CAC17276FE2A6B7D710E96B69EC1D79DE8BE21AD828C58B45B804'
$checksumType = 'sha256'
Install-ChocolateyPackage 'android-sdk' 'exe' '/S' '/ALLUSERS=1' $downUrl -validExitCodes @(0)   -Checksum "$checksum" -ChecksumType "$checksumType"

if ("${Env:ProgramFiles(x86)}")
{
    Install-ChocolateyPath "${Env:ProgramFiles(x86)}\Android\android-sdk\tools" 'Machine'
    Install-ChocolateyPath "${Env:ProgramFiles(x86)}\Android\android-sdk\platform-tools" 'Machine'
    Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' "${Env:ProgramFiles(x86)}\Android\android-sdk" 'Machine'
}
else
{
    Install-ChocolateyPath "${Env:ProgramFiles}\Android\android-sdk\tools" 'Machine'
    Install-ChocolateyPath "${Env:ProgramFiles}\Android\android-sdk\platform-tools" 'Machine'
    Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' "${Env:ProgramFiles}\Android\android-sdk" 'Machine'
}
