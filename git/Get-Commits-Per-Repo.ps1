# Dependency - git
# Get all the commits from all the repos in the folder
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

$dirs = Get-ChildItem -Directory $Path

foreach($dir in $dirs)
{
	Set-Location $dir
	Split-Path -Path (Get-Location) -Leaf
	git shortlog -sne --author="\(jrojaslopez\)" --after="01 Jan 2022" --before="22 Oct 2022"
	Write-Output ""
	Set-Location ..
}