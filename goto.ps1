<#
.DESCRIPTION
If $path is a directory, cd there.
If $path is a file, go to its directory.
.SYNOPSIS
If $path is a directory, cd there.
If $path is a file, go to its directory.
#>

param (
    [Parameter(Mandatory=$true)][string]$path
)

# GetAttributes returns a string, which we convert to an array.
$sep = [System.IO.Path]::DirectorySeparatorChar
$path = "$pwd$sep$path"
$path = [System.IO.Path]::GetFullPath($path)
$attributeString = [System.IO.File]::GetAttributes($path)
if ($null -eq $attributeString) {
    exit 1
}
$attributes = $attributeString -split ", "
if ($attributes.Contains("Directory")) {
    Set-Location $path
} else {
    $directory = [System.IO.Path]::GetDirectoryName($path)
    Set-Location -Path $directory
}
