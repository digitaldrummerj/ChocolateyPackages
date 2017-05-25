$downUrl = '{{DownloadUrl}}'
$checksum = '{checksum}'
$checksumType = 'sha256'
Install-ChocolateyPackage '{{PackageName}}' 'exe' '/S' '/ALLUSERS=1' $downUrl -validExitCodes @(0)  -Checksum "$checksum" -ChecksumType "$checksumType"

if ("${Env:ProgramFiles(x86)}")
{
    Install-ChocolateyPath "${Env:ProgramFiles(x86)}\Android\android-sdk\tools" 'Machine'
	Install-ChocolateyPath "${Env:ProgramFiles(x86)}\Android\android-sdk\platform-tools" 'Machine'
}
else
{
	Install-ChocolateyPath "${Env:ProgramFiles}\Android\android-sdk\tools" 'Machine'
    Install-ChocolateyPath "${Env:ProgramFiles}\Android\android-sdk\platform-tools" 'Machine'
}
