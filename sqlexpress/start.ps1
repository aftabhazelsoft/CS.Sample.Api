# The script sets the sa password and start the SQL Service 
# Also it attaches additional database from the disk

param(
[Parameter(Mandatory=$false)]
[string]$sa_password,

[Parameter(Mandatory=$false)]
[string]$ACCEPT_EULA,

[Parameter(Mandatory=$false)]
[string]$attach_db1_name,

[Parameter(Mandatory=$false)]
[string]$attach_db1_file,

[Parameter(Mandatory=$false)]
[string]$attach_db1_log
)

if($ACCEPT_EULA -ne "Y" -And $ACCEPT_EULA -ne "y")
{
	Write-Verbose "ERROR: You must accept the End User License Agreement before this container can start."
	Write-Verbose "Set the environment variable ACCEPT_EULA to 'Y' if you accept the agreement."

	exit 1 
}

# start the service
Write-Verbose "Starting SQL Server"
start-service MSSQL`$SQLEXPRESS

if($sa_password -eq "_") {
	$secretPath = $env:sa_password_path
	if (Test-Path $secretPath) {
		$sa_password = Get-Content -Raw $secretPath
	}
	else {
		Write-Verbose "WARN: Using default SA password, secret file not found at: $secretPath"
	}
}

if($sa_password -ne "_")
{
	Write-Verbose "Changing SA login credentials"
	$sqlcmd = "ALTER LOGIN sa with password=" +"'" + $sa_password + "'" + ";ALTER LOGIN sa ENABLE;"
	& sqlcmd -Q $sqlcmd
}

if ($null -ne $attach_db1_name -And $null -ne $attach_db1_file -And $null -ne $attach_db1_log)
{
	Write-Verbose "Attaching $($attach_db1_name) database"
		
	$files = @();
	$files += "(FILENAME = N'$($attach_db1_file)')"; 
	$files += "(FILENAME = N'$($attach_db1_log)')"; 

	$files = $files -join ","
	$sqlcmd = "IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = '" + $($attach_db1_name) + "') BEGIN EXEC sp_detach_db [$($attach_db1_name)] END;CREATE DATABASE [$($attach_db1_name)] ON $($files) FOR ATTACH;"

	Write-Verbose "Invoke-Sqlcmd -Query $($sqlcmd)"
	& sqlcmd -Q $sqlcmd
}

Write-Verbose "Started SQL Server."

$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
	Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
	$lastCheck = Get-Date 
	Start-Sleep -Seconds 2 
}
