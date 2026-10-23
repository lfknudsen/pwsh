<#
.SYNOPSIS
New-Dir creates a new directory, then enters it.
.DESCRIPTION
New-Dir creates a new directory, then enters it.
.PARAMETER <path>
The name of the new directory.
#>

param (
    [Parameter(Mandatory=$true)][string]$path = $(Read-Host "Enter name of new directory:")
)

New-Item -Type directory -Name $args[0] > $Null
Set-Location $args[0]
