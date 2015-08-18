try {
	# Common Functions and Config
    . (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')

	
    $params = @{
        PackageName = $package;
        Url = "https://dl.google.com/dl/android/studio/install/$majorVersion/android-studio-ide-$buildVersion-windows.exe"
		InstallerType = "exe";
		SilentArgs = "/S";
		Checksum = "d70fb49d03db9dded19c891a92452601e39272f4";
		CheckSumType = "sha1";
		validExitCodes = @(0,1223);
    }
    
    Install-ChocolateyPackage @params
        
    $customArgs = $env:chocolateyPackageParameters
    $settings = GetArguments $customArgs
    $studioExe = GetStudioExe
	
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
  throw $_.Exception
}