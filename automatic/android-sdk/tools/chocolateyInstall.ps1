$downUrl = '{{DownloadUrl}}'
$checksum = '{checksum}'
$checksumType = 'sha256'
Install-ChocolateyPackage '{{PackageName}}' 'exe' '/S' $downUrl -validExitCodes @(0)   -Checksum "$checksum" -ChecksumType "$checksumType"

Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\tools" 'Machine'
Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\platform-tools" 'Machine'
