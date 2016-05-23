$installerType = 'EXE' 
$url = "http://download.jetbrains.com/webstorm/WebStorm-2016.1.2.exe" 
$url64 = $url 
$silentArgs = '/S' 
$validExitCodes = @(0) 


Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes