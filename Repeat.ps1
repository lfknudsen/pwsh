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

$totalLength = $repetitions * $value.Length
$output = New-Object char[] $totalLength
$val = $value.TrimEnd("\r\n").ToCharArray()
$len = $val.Length
for ($i = 0; $i -lt $repetitions; $i++) {
    for ($j = 0; $j -lt $len; $j++) {
        $output[$i * $len + $j] = $val[$j]
    }
    
}
return [System.String]::Concat($output)