<#
.SYNOPSIS
Returns true if the given alias exists, and false otherwise.
.DESCRIPTION
Returns true if the given alias exists, and false otherwise.
#>
param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true
    )]
    [string]$alias
)
Get-Alias $alias *> $null
return $?