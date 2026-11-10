<#
.SYNOPSIS
Create multiple directories at once, without the extraneous text to stdout that mkdir normally does.
.DESCRIPTION
Create multiple directories at once, without the extraneous text to stdout that mkdir normally does.
#>

param (
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )][string[]]$paths
)

process {
    foreach ($path in $paths) {
        New-Item -Type directory -Name $arg 1> $Null
        if (!$?) {
            break
        }
    }
}