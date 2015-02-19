$package = 'jdk7'
$build = '14'
$jdk_version = '7u72' 
$java_version = "1.7.0_72"
$uninstall_id = "17072" 
$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments = ""


function use64bit() {
    $is64bitOS = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match '(x64)'
    return $is64bitOS
}

function has_file($filename) {
    return Test-Path $filename
}

function get-programfilesdir() {
    $use64bit = use64bit
    $programFiles = (Get-Item "Env:ProgramFiles").Value

    return $programFiles
}

function checkIfInstalled()
{
    $jdkPath = "HKLM:\SOFTWARE\JavaSoft\Java Development Kit"

    if (Test-Path -Path $jdkPath)
    {
        $installedJdkVersion = dir $jdkPath | select -expa pschildname -Last 1
    
		Write-Debug "Installed JDK Version: $installedJdkVersion"
		$isInstalled = $installedJdkVersion -eq  $java_version	
		
		Write-Debug "Jdk IsInstalled: $isInstalled"
		return $isinstalled
    }
	
	Write-Debug "Jdk Is Not Installed"
	return $false    
}

function download-from-oracle($url, $output_filename) {
    if (-not (has_file($output_fileName))) {
        Write-Host  "Downloading JDK from $url"

        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        $client = New-Object Net.WebClient
        $client.Proxy = [System.Net.WebRequest]::DefaultWebProxy
        $dummy = $client.Headers.Add('Cookie', 'gpw_e24=http://www.oracle.com; oraclelicense=accept-securebackup-cookie')
        $dummy = $client.DownloadFile($url, $output_filename)
        
        Write-Host  "Completed Downloading JDK from $url"
    }  
}

function download-jdk-file($url, $output_filename) {
    $dummy = download-from-oracle $url $output_filename
}

function download-jdk() {
    $arch = get-arch
    $filename = "jdk-$jdk_version-windows-$arch.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/$jdk_version-b$build/$filename"
    $output_filename = Join-Path $script_path $filename

    $dummy = download-jdk-file $url $output_filename

    return $output_filename
}


function get-java-home() {
    $program_files = get-programfilesdir
    return Join-Path $program_files "Java\jdk$java_version" #jdk1.6.0_17
}

function get-java-bin() {
    $java_home = get-java-home
    return Join-Path $java_home 'bin'
}

function get-arch() {
    if(use64bit) {
        return "x64"
    } else {
        return "i586"
    }
}

function chocolatey-install() {

    if (checkIfInstalled)
    {
        Write-Host "JDK $java_version already installed."
        Write-ChocolateySuccess $package
        return
    }
 

    $jdk_file = download-jdk
    $arch = get-arch
    $java_home = get-java-home
    $java_bin = get-java-bin

    Write-Host "Installing JDK $jdk_version($arch) to $java_home"
    Install-ChocolateyInstallPackage $package 'exe' "/s" $jdk_file          

    Install-ChocolateyPath $java_bin 'Machine'              
         
    if ([Environment]::GetEnvironmentVariable('CLASSPATH','Machine') -eq $null) {
        Install-ChocolateyEnvironmentVariable 'CLASSPATH' '.;' 'Machine'
    }

    Install-ChocolateyEnvironmentVariable 'JAVA_HOME' $java_home 'Machine'
    Write-ChocolateySuccess $package
}