<#
.SYNOPSIS
Returns the base directory name of the current working directory.
.DESCRIPTION
Returns the base directory name of the current working directory.
#>

return [System.IO.Path]::GetFileName($pwd)