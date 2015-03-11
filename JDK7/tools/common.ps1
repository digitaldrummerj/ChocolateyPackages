$package = 'jdk7'
$build = '14'
$jdk_version = '7u72' 
$java_version = "1.7.0_72"
$uninstall_id = "17072" 
$java_home = get-java-home

# Check if OS is 32 bit or 64 Bit
function use64bit() {
    $is64bitOS = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match '(x64)'
    return $is64bitOS
}

# Check if a file exist or not
function has_file($filename) {
    return Test-Path $filename
}

# Get the Program Files Directory
function get-programfilesdir() {
    $programFiles = (Get-Item "Env:ProgramFiles").Value

    return $programFiles
}

# Check if JDK Version is already installed or not
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

# Helper function to properly download a given JDK version from Oracle
# Key for this to work is to set the Header Cookie Information
# Will only if it doesn't already exist on the local system
function download-from-oracle($url, $output_filename) {
    if (-not (has_file($output_fileName))) {
        Write-Host  "Downloading JDK from $url"

        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        $client = New-Object Net.WebClient
        $client.Proxy = [System.Net.WebRequest]::DefaultWebProxy
        $client.Headers.Add('Cookie', 'gpw_e24=http://www.oracle.com; oraclelicense=accept-securebackup-cookie')
        $client.DownloadFile($url, $output_filename)
        
        Write-Host  "Completed Downloading JDK from $url"
    }  
}

# Download the JDK version that we need.
function download-jdk() {
    
    $filename = "jdk-$jdk_version-windows-$arch.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/$jdk_version-b$build/$filename"
    $output_filename = Join-Path $script_path $filename
	
    download-from-oracle $url $output_filename
	
    return $output_filename
}


# Figure out where the JAVA_HOME directory is
function get-java-home() {
    $program_files = get-programfilesdir
    return Join-Path $program_files "Java\jdk$java_version" #jdk1.6.0_17
}

# Figure out where the JAVA_HOME bin directory is
function get-java-bin() {
    $java_home = get-java-home
    return Join-Path $java_home 'bin'
}

# Helper function to figure out the architecture for the oracle download.  
# Either x64 or i586
function get-arch() {
    if(use64bit) {
        return "x64"
    } else {
        return "i586"
    }
}