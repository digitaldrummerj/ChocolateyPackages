$packageName = 'Webstorm'
$installerType = 'EXE' 
$url = 'https://download.jetbrains.com/webstorm/WebStorm-2017.1.exe'
$url64 = $url 
$silentArgs = '/S' 
$validExitCodes = @(0) 
$checksumType = 'sha256';
$checksum = '9a3f7a8ce59a4183d6a75470bc17624240e1d5a88c97df39233ce5462a0bd5e7';

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64  -validExitCodes $validExitCodes -Checksum64 $checksum -ChecksumType64 $checksumType -ChecksumType "$checksumType" -Checksum $checksum
