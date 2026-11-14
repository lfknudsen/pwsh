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
cd $base
