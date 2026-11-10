<#
.SYNOPSIS
Outputs a string consisting of the second argument repeated an amount of times equal
to the first argument.
.DESCRIPTION
Outputs a string consisting of <string> repeated <n> times:

Repeat <n> <string>
#>

param (
    [Parameter(Mandatory)][int]$repetitions,
    [Parameter(Mandatory, ValueFromPipeline)][string]$value
)

if ($value.Length -eq 1) {
    $output = [System.String]::new($value[0], $repetitions)
    return $output
}

$output = ""
for ($i = 0; $i -lt $repetitions; $i++) {
    $output += $value
}
return $output