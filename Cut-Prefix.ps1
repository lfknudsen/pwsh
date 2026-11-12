<#
.SYNOPSIS
Cut the given prefix from the given string(s).
If the prefix isn't found, the string is unaltered.
.DESCRIPTION
Cut the given prefix from the given string(s).
If the prefix isn't found, the string is unaltered.
#>
param (
    [Parameter(
        Mandatory
    )][string]$prefix,
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )][string[]]$value
)

process {
    for ($i = 0; $i -lt $value.Length; $i++) {
        $foundAt = $value[$i].IndexOf($prefix)
        if ($foundAt -ge 0) {
            $value[$i] = $value[$i].Substring($foundAt)
        }
    }
    return $value
}