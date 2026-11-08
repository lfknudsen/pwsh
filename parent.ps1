<#
.SYNOPSIS
Returns the path to the parent directory.
.DESCRIPTION
Returns the path to the parent directory.

`cd ..` is equivalent to `parent | cd`
#>

return [System.IO.Path]::GetDirectoryName($pwd)