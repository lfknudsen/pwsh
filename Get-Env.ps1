<#
.SYNOPSIS
Returns the value of the given environment variable(s) as a list.
.DESCRIPTION
Returns the value of the given environment variable(s) as a list.
#>
param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true
    )]
    [string[]]$variable
)

foreach ($var in $variable) {
    $env = [Environment]::GetEnvironmentVariable($var).TrimEnd(';')
    if ($env -eq "") {
        continue
    }
    $env -split ';'
}
