$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments = ""

$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$common = $(Join-Path $script_path "common.ps1")
. $common

try {
#    $params = "$env:chocolateyPackageParameters" # -params '"x64=false;path=c:\\java\\jdk"'
#    $params = (ConvertFrom-StringData $params.Replace(";", "`n")) 
    
    if (checkIfInstalled)
    {
        Write-Host "JDK $java_version already installed."
        return
    } 

	# Download JDK file and store locally
	$arch = get-arch
    $jdk_file = download-jdk
	$java_home = get-java-home

	# Install JDK
    Write-Host "Installing JDK $jdk_version($arch) to $java_home"
    Install-ChocolateyInstallPackage $package 'exe' "/s" $jdk_file          
	Write-Host "Completed Installing JDK $jdk_version($arch) to $java_home"
	
	# Add java bin folder to Path
	$java_bin = get-java-bin
	Write-Host "Adding $java_bin to the Path"    
    Install-ChocolateyPath $java_bin 'Machine' 
	Write-Host "Completed Adding $java_bin to the Path"	

	# Add CLASSPATH environment variable if it doesn't exist
    if ([Environment]::GetEnvironmentVariable('CLASSPATH','Machine') -eq $null) {
		Write-Host "Adding CLASSPATH Environment Variable"    
        Install-ChocolateyEnvironmentVariable 'CLASSPATH' '.;' 'Machine'
		Write-Host "Completed Adding CLASSPATH Environment Variable"    
    }

	# Add JAVA_HOME environment variable if it doesn't exist

    if ([Environment]::GetEnvironmentVariable('JAVA_HOME','Machine') -eq $null) {
		Write-Host "Adding JAVA_HOME Environment Variable"  
		$java_home = get-java-home
        Install-ChocolateyEnvironmentVariable 'JAVA_HOME' $java_home 'Machine'
		Write-Host "Completed Adding JAVA_HOME Environment Variable"    
    }
	
    $env:chocolateyInstallArguments = $customArgs 
} catch {
    $env:chocolateyInstallArguments = $customArgs 
    if ($_.Exception.InnerException) {
        $msg = $_.Exception.InnerException.Message
    } else {
        $msg = $_.Exception.Message
    }
    
    Write-ChocolateyFailure $package "$msg"
    throw 
}  
