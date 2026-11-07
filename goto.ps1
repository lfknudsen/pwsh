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

# Returns the index of the first instance of $Value in $Array, or -1 if it isn't present.
function Find-Value {
    param (
        [Parameter(Mandatory)]
        [Object[]]$Array,

        [Parameter(Mandatory)]
        [Object[]]$Value
    )
    for ($i = 0; $i -lt $Array.Count; $i++) {
        if ($Array[${i}] -eq $Value) {
            return ${i}
        }
    }
    return -1
}

# GetAttributes returns a string, which we convert to an array.
$attributes = [System.IO.File]::GetAttributes($path) -split ", "

$index = Find-Value $attributes "Directory"
if ($index -eq -1) {
    $directory = [System.IO.Path]::GetDirectoryName($path)
    Set-Location -Path $directory
} else {
    Set-Location $path
}
