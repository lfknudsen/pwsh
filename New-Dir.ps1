<#
.SYNOPSIS
New-Dir creates a new directory, then enters it.
.DESCRIPTION
New-Dir creates a new directory, then enters it.
.PARAMETER <name>
#>

New-Item -Type directory -Name $args[0] > $Null
Set-Location $args[0]
