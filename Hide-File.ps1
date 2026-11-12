<#
.SYNOPSIS
Hides the given file(s).
.DESCRIPTION
Hides the given file(s).
.PARAMETER u
If set, the programme reveals the file(s) instead of hiding them.
.PARAMETER quiet
If set, do not print anything to stdout on error.
.PARAMETER files
Path(s) to the file(s) to execute this programme on.
#>

param(
	[Parameter()][switch]$quiet = $false,
	[Parameter()][switch]$u = $false,
	[Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments)][string[]]$files
)

process {
	# Exit with error code and error message if no arguments given.
	if ($files.count -eq 0) {
		if (!$quiet) {
			Write-Error "No arguments given."
		}
		return -1
	}

	# Given an array and a value, returns the index of the first occurence of the value.
	# If the value is not found in the array, returns -1.
	function Find-Value {
		param (
			[Parameter(Mandatory)]
			[Object[]]$Array,

			[Parameter(Mandatory)]
			[Object[]]$Value
		)
		for ($i = 0; $i -lt $Array.Count; $i++) {
			if ($Array[${i}] -eq $Value) {
				return ${i}
			}
		}
		return -1
	}

	function Set-Attribute {
		param (
			[Parameter(Mandatory)]
			[System.IO.FileAttributes[]]$AttributeList,

			[Parameter(Mandatory)]
			[System.IO.FileAttributes]$NewAttribute
		)

		$index = Find-Value $AttributeList $NewAttribute

		if ($index -eq -1) {
			$AttributeList += $NewAttribute
		}
		return $AttributeList
	}

	function Remove-Attribute {
		param (
			[Parameter(Mandatory)]
			[System.IO.FileAttributes[]]$AttributeList,

			[Parameter(Mandatory)]
			[System.IO.FileAttributes]$NewAttribute
		)

		if ($AttributeList.Count -eq 0) {
			Write-Debug "Length of attributes was 0"
			return $AttributeList
		}

		$index = Find-Value $AttributeList $NewAttribute
		if ($index -eq -1) {
			Write-Debug "$NewAttribute was not found in $AttributeList"
			return $AttributeList
		}

		if ($AttributeList.Count -eq 1) {
			return @()
		}

		if ($index -eq $AttributeList.Count - 1) {
			return $AttributeList[0..($AttributeList.Length - 2)]
		}
		if ($index -eq 0) {
			return $AttributeList[1..($AttributeList.Length - 1)]
		}

		return $AttributeList[0..$index - 1] + $AttributeList[$index + 1..($AttributeList.Length - 1)]
	}

	# Regexp to check if the file attributes are given as an integer or as a comma-separated "list"
	$rx = [System.Text.RegularExpressions.Regex]::new("^[0-9]+$")
	$failures = 0
	foreach ($name in $files) {
		$file = Get-Item -Force -ErrorAction SilentlyContinue $name
		if ($null -eq $file) {
			if (!$quiet) {
				Write-Host "$file is either a system file or not a file at all."
			}
			$failures++
			continue
		}

		if ($null -eq $file.Attributes -or $rx.IsMatch($file.Attributes)) {
			if ($u) {
				$file.Attributes = $file.Attributes -bxor [System.IO.FileAttributes]::Hidden
			} else {
				$file.Attributes = $file.Attributes -bor [System.IO.FileAttributes]::Hidden
			}
			continue
		}

		$attributes = $file.Attributes -split ", "
		if ($u) {
			$file.Attributes = Remove-Attribute $attributes "Hidden"
		} else {
			$file.Attributes = Set-Attribute $attributes "Hidden"
		}
	}
	exit $failures
}