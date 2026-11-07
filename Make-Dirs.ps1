<#
.SYNOPSIS
Create multiple directories at once, without the extraneous text to stdout that mkdir normally does.
.DESCRIPTION
Create multiple directories at once, without the extraneous text to stdout that mkdir normally does.
#>
foreach ($arg in $args) {
    New-Item -Type directory -Name $arg > $Null
}