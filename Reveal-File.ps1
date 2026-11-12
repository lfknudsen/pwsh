<#
.SYNOPSIS
Removes the 'Hidden' attribute from the given file(s), if present.
.DESCRIPTION
Removes the 'Hidden' attribute from the given file(s), if present.
#>

param (
    [Parameter(Mandatory = $false)]
    [switch]$quiet = $false,
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromRemainingArguments)]
    [string[]]$files
)

process {
	function Report {
		param (
			[Parameter(Mandatory)]
			[string]$message
		)

		if (!$quiet) {
			Write-Host $message
		}
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

    # Remove element at the given index.
    # Will throw an exception if the index is negative, or outside the range
    # of the array.
    function Remove-At {
        param (
            [Parameter(Mandatory)]
            [Object[]]$array,

            [Parameter(Mandatory)]
            [Object]$index
        )

        if ($index -lt 0) {
            throw "Index must be a non-negative value."
        }

        if ($array.Count -le $index) {
            throw "Out of range: Length was ${array.Count} but index was $index."
        }

        $last = $array.Count - 1

        if ($index -eq 0) {
            if ($array.Count -eq 1) {
                return @()
            }
            return $array[1..$last]
        }

        if ($index -eq $last) {
            if ($array.Count -eq 2) {
                return @($array[0])
            }
            return $array[0..$last - 1]
        }

        return $array[0..$index - 1] + $array[$index + 1..$last]
    }


	# Regexp to check if the file attributes are given as an integer or as a comma-separated "list"
	$rx = [System.Text.RegularExpressions.Regex]::new("^[0-9]+$")
    $esc = [char]27
    $failures = 0 
    foreach ($name in $files) {
        $file = Get-Item -Force -ErrorAction SilentlyContinue $name
        if ($null -eq $file) {
            Report "$esc[033m$name$esc[0m is either a system file or not a file at all."
            $failures++
            continue
        }

        if ($null -eq $file.Attributes -or $rx.IsMatch($file.Attributes)) {
            $file.Attributes = $file.Attributes -bxor [System.IO.FileAttributes]::Hidden
            Report "$esc[033m$name$esc[0m has been revealed."
            continue
        }

        $attributes = $file.Attributes -split ", "
        $index = Find-Value $attributes "Hidden"
        if ($index -ne -1) {
            $file.Attributes = Remove-At $attributes $index
        }
        Report "$esc[033m$name$esc[0m has been revealed."
    }
    Exit $failures
}