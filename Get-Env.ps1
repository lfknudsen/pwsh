<#
.SYNOPSIS
Returns the value of the given environment variable(s) as a list.
.DESCRIPTION
Returns the value of the given environment variable(s) as a list.
.PARAMETER sort
If set, the output list will be sorted alphabetically.
.PARAMETER dedup
If set, the output list will have duplicates removed. Implies -sort.
.PARAMETER variable
The name or names of the environment variables whose values should be printed. Default is "Path".
If "*", print values of all environment variables.
#>
param (
    [Parameter(
        Mandatory = $false
    )]
    [switch]$sort = $false,
    
    [Parameter(
        Mandatory = $false
    )]
    [switch]$dedup = $false,

    [Parameter(
        Mandatory = $false,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true
    )]
    [string[]]$variable = "Path"
)

process {
    $values = @()
    if ($variable.Count -eq 0 -and $variable[0] -eq "*") {
        $variable = [Environment]::GetEnvironmentVariables().Keys
    }

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

    if ($values.Count -eq 0) {
        return
    }

    if ($dedup) {
        $sort = $true
    }

    if ($sort) {
        [System.Array]::Sort($values)
    }
    if ($dedup) {
        $prededupped = $values.Clone()
        $values = @($prededupped[0])
        for ($i = 1; $i -lt $prededupped.Count; $i++) {
            if ($prededupped[$i] -ne $values[$values.Count - 1]) {
                $values += $prededupped[$i]
            }
        }
    }

    Write-Output $values
}