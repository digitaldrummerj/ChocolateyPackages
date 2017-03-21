$packageName = 'Webstorm'
$installerType = 'EXE' 
$url = 'https://download.jetbrains.com/webstorm/WebStorm-2016.3.4.exe'
$url64 = $url 
$silentArgs = '/S' 
$validExitCodes = @(0) 
$checksumType = 'sha256';
$checksum = '962f0bbf94a76dc79dd2d9c1b898abe9f9bb3201cb71cdb25d6731290d1955b9';

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64  -validExitCodes $validExitCodes -Checksum64 $checksum -ChecksumType64 $checksumType -ChecksumType "$checksumType" -Checksum $checksum
