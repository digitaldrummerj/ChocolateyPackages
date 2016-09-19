$downUrl = '{{DownloadUrl}}'
$checksum = '{checksum}'
$checksumType = 'sha256'
Install-ChocolateyPackage '{{PackageName}}' 'exe' '/S' $downUrl -validExitCodes @(0)  -Checksum "$checksum" -ChecksumType "$checksumType"

if ("${Env:ProgramFiles(x86)}")
{
    Install-ChocolateyPath "${Env:ProgramFiles(x86}\Android\android-sdk\tools" 'Machine'
}
else
{
    Install-ChocolateyPath "${Env:ProgramFiles}\Android\android-sdk\platform-tools" 'Machine'
}
