<#
.SYNOPSIS
New-Dir creates a new directory, then enters it.
.DESCRIPTION
New-Dir creates a new directory, then enters it.
#>

param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true
    )
    ][Object[]]$Args
)

if ($Args.Count -eq 0) {
    Write-Error "Must provide path argument."
    exit 1
}
$path = $Args[0]
if ($Args.Count -gt 1) {
    $path = [System.String]::Join(" ", $Args)
}

if ([System.String]::IsNullOrWhiteSpace($path)) {
    Write-Error "Must provide non-empty path argument."
    exit 1
}
New-Item -Type directory -Name $path > $Null
Set-Location $path
