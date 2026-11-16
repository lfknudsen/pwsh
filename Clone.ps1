<#
.SYNOPSIS
Convenience script for cloning a Git repository.
Will automatically prepend 'https://' if necessary, and will
enter the new directory after it has been created.
.DESCRIPTION
Convenience script for cloning a Git repository.
Will automatically prepend 'https://' if necessary, and will
enter the new directory after it has been created.
#>
param (
    [Parameter(Mandatory)][string]$url
)

if ([String]::IsNullOrWhitespace($url)) {
    Write-Error "Must provide a valid URL."
    Exit 1
}

$base = $url.TrimEnd("/")
$base = [System.IO.Path]::GetFileNameWithoutExtension($base)

if (!$url.StartsWith("https://")) {
    $url = "https://$url"
}

git clone $url
if (!$?) {
    Exit 1
}
Change-Dir $base

# If it's my own repo, I add the alternative remotes to it.
if (!$url.Contains("lfknudsen")) {
    Exit 0
}

$hostDomain = ""
$hosts = @("gitlab.com", "codeberg.org", "github.com")
foreach ($h in $hosts) {
    if ($url.Contains($h)) {
        $hosts = $hosts -ne $h
        $hostdomain = $h
        break
    }
}
if ($hostDomain -eq "") {
    Write-Error "Not a known host."
    Exit 1
}

$backupUrl = $url.Replace($hostDomain, $hosts[0])
git remote add backup1 $backupUrl
if (!$?) { Exit 1 }
$backupUrl = $url.Replace($hostDomain, $hosts[1])
git remote add backup2 $backupUrl
if (!$?) { Exit 1 }
Exit 0