$package = 'AndroidStudio'
$majorVersion = '1.0.1'
$buildVersion = '135.1641136'
$extractionPath = "C:/Google"


try {
    $params = @{
        PackageName = $package;
        Url = "https://dl.google.com/dl/android/studio/ide-zips/$majorVersion/android-studio-ide-$buildVersion-windows.zip";
        unzipLocation = $extractionPath;    
    }
    
    Install-ChocolateyZipPackage @params
    
    
    $studioExe = (gci "${extractionPath}/android-studio/bin/studio64.exe").FullName | sort -Descending | Select -first 1
    
    . (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')
    $customArgs = $env:chocolateyPackageParameters
    $settings = GetArguments $customArgs
    
    
    
    
    if ($settings.addtodesktop -eq "true")
    {
        Write-Host "AddToDesktop Value: " $settings.addtodesktop
        Install-ChocolateyDesktopLink $studioExe
    }
    
    if ($settings.pinnedtotaskbar -eq "true")
    {
        Write-Host "PinnedToTaskbar Value: " $settings.pinnedtotaskbar
        Install-ChocolateyPinnedTaskBarItem $studioExe
    }
    
    Write-ChocolateySuccess $package
} 
catch 
{
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}