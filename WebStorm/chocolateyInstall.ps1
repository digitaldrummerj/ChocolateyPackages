$installerType = 'EXE' 
$url = "https://download.jetbrains.com/webstorm/WebStorm-2016.3.3.exe" 
$url64 = $url 
$silentArgs = '/S' 
$validExitCodes = @(0) 
$checksumType = 'sha256';
$checksum = '48b866ac9e2d8860b1c60b4a6da77e8b725467f0c49ec9c9a765429718ea582e';

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes -Checksum64 "$checksum" -ChecksumType64 $checksumType -ChecksumType "$checksumType" -Checksum "$checksum"  
