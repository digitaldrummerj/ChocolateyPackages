
# Common Functions and Config
. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'Common.ps1')

if (Test-Path ($installDir)) {
    $uninstallExe = GetUninstallFile
    
    $params = @{
        PackageName = $package;
        FileType = "exe";
        SilentArgs = "/S";
        File = $uninstallExe;
    }

    Uninstall-ChocolateyPackage @params
}

# Url = "https://dl.google.com/dl/android/studio/install/$majorVersion/android-studio-ide-$buildVersion-windows.exe"
# Checksum = "$checksum";
# CheckSumType = "sha1";

$params = @{
	PackageName = $package;
	Url = '{{DownloadUrl}}'
	InstallerType = "exe";
	SilentArgs = "/S";	
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
