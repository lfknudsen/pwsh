<#
.SYNOPSIS
Removes the 'Hidden' attribute from the given file(s), if present.
.DESCRIPTION
Removes the 'Hidden' attribute from the given file(s), if present.
#>

# Exit with error code and error message if no arguments given.
if ($args.count -eq 0) {
    Write-Host "No arguments given."
    return 1
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

foreach ($name in $args) {
    $file = Get-Item -Force -ErrorAction SilentlyContinue $name
    if ($null -eq $file) {
        Write-Host "$file is either a system file or not a file at all."
        continue
    }
    $attributes = $file.Attributes -split ", "
    $index = Find-Value $attributes "Hidden"
    if ($index -ne -1) {
        $file.Attributes = Remove-At $attributes $index
    }
}