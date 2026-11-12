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
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromRemainingArguments
    )][string[]]$value
)

process {
    foreach ($chars in $value) {
        if ($chars.Length -eq 1) {
            $output = [System.String]::new($chars[0], $repetitions)
            Write-Output $output
            continue
        }

        $totalLength = $repetitions * $chars.Length
        $output = New-Object char[] $totalLength
        $val = $chars.TrimEnd("\r\n").ToCharArray()
        $len = $val.Length
        for ($i = 0; $i -lt $repetitions; $i++) {
            for ($j = 0; $j -lt $len; $j++) {
                $output[$i * $len + $j] = $val[$j]
            }
    
        }
        Write-Output ([System.String]::Concat($output))
    }
}