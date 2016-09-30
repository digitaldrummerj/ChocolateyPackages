
UnInstall-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\tools" 'Machine'
UnInstall-ChocolateyPath "${Env:LOCALAPPDATA}\Android\android-sdk\platform-tools" 'Machine'

$packageName = '{{PackageName}}'
$unpath = "${Env:LOCALAPPDATA}\Android\android-sdk\uninstall.exe"
Uninstall-ChocolateyPackage $packageName 'exe' '/S' $unpath
  
