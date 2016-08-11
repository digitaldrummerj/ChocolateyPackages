$installerType = 'EXE' 
$url = "https://download.jetbrains.com/webstorm/WebStorm-2016.2.1.exe" 
$url64 = $url 
$silentArgs = '/S' 
$validExitCodes = @(0) 
$checksumType = 'sha256';
$checksum = 'ff8e2babefff47b23beb7960d83f289b5725f92e30f12d6b628524ae95cee544';

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes -Checksum64 "$checksum" -ChecksumType64 $checksumType -ChecksumType "$checksumType" -Checksum "$checksum"  
