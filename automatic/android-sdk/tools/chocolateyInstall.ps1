$downUrl = '{{DownloadUrl}}'
Install-ChocolateyPackage '{{PackageName}}' 'exe' '/S' $downUrl -validExitCodes @(0)

Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\tools" 'Machine'
Install-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\platform-tools" 'Machine'
