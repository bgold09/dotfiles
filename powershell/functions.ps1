# Adapted from: http://newdelhipowershellusergroup.blogspot.in/2012/09/find-files-using-powershell.html
function Find-Files {
	[CmdletBinding()]
	
	param(
		[Parameter(Mandatory=$true)][string]$fileName,
		[Parameter(Mandatory=$true)][string]$filePath
	)

	Get-ChildItem -Recurse -Force $filePath -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and  ( $_.Name -like "*$fileName*") } | Select-Object Name,Directory| Format-Table -AutoSize *
}
