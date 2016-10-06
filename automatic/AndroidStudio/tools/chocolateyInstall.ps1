
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


$params = @{
	PackageName = $package;
	Url = '{{DownloadUrl}}'
	InstallerType = "exe";
	SilentArgs = "/S";	
	validExitCodes = @(0,1223);
	Checksum = '43f84de7e61f37880a126c3d567b7fa6cb90c90e' #'{checksum}'
	ChecksumType = 'sha1'
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
