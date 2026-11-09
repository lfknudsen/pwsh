<#
.SYNOPSIS
Returns the value of the given environment variable(s) as a list.
.DESCRIPTION
Returns the value of the given environment variable(s) as a list.
#>
param (
    [Parameter(
        Mandatory=$false
    )]
    [switch]$sort = $false,

    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true
    )]
    [string[]]$variable
)

if ($sort) {
    $values = @()
    foreach ($var in $variable) {
        $env = [Environment]::GetEnvironmentVariable($var).TrimEnd(';')
        if ($env -eq "") {
            continue
        }
        $varvalues = $env -split ';'
        foreach ($value in $varvalues) {
            $values += $value
        }
    }
    [System.Array]::Sort($values)
    Write-Output $values
    exit
}

foreach ($var in $variable) {
    $env = [Environment]::GetEnvironmentVariable($var).TrimEnd(';')
    if ($env -eq "") {
        continue
    }
    $env -split ';'
}
