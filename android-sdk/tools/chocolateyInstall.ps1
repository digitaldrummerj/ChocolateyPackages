$downUrl = 'https://dl.google.com/android/repository/tools_r25.2.3-windows.zip'
$checksum = '23d5686ffe489e5a1af95253b153ce9d6f933e5dbabe14c494631234697a0e08'
$checksumType = 'sha256'
$destination = "${Env:ProgramFiles}\Android\android-sdk"

Install-ChocolateyZipPackage -PackageName 'android-sdk' -url $downUrl -unzipLocation $destination -ChecksumType "$checksumType" -Checksum "$checksum"
 
Install-ChocolateyPath "${destination}\tools" 'Machine'
Install-ChocolateyPath "${destination}\platform-tools" 'Machine'
Install-ChocolateyEnvironmentVariable 'ANDROID_HOME' "${destination}" 'Machine'
