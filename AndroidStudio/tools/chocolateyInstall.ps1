
# Common Functions and Config
. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')

$uninstallExe = GetUninstallFile
if (Test-Path ($uninstallExe)) {
    
    $params = @{
        PackageName = $package;
        FileType = "exe";
        SilentArgs = "/S";
        File = $uninstallExe;
    }

    Uninstall-ChocolateyPackage @params
}

$params = @{
	PackageName = $package;
	Url = "https://dl.google.com/dl/android/studio/install/$majorVersion/android-studio-ide-$buildVersion-windows.exe"
	InstallerType = "exe";
	SilentArgs = "/S";
	Checksum = "$checksum";
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
	Install-ChocolateyShortcut $studioExe
}

if ($settings.pinnedtotaskbar -eq "true")
{
	Write-Host "PinnedToTaskbar Value: " $settings.pinnedtotaskbar
	Install-ChocolateyPinnedTaskBarItem $studioExe
}
