<#
.SYNOPSIS
Removes the given alias if it exists.
Unlike `Remove-Item alias:<alias name>`, this will not write to stderr if the alias did not exist.
.DESCRIPTION
Removes the given alias.
Unlike `Remove-Item alias:<alias name>`, this will not write to stderr if the alias did not exist.
#>
param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true
    )]
    [string]$alias
)
if (Alias-Exists $alias) {
    Remove-Item Alias:$alias
}