# Exit with error code and error message if no arguments given.
if ($args.count -eq 0) {
	Write-Host "No arguments given."
	return 1
}

# Parses flag arguments.
# As per POSIX standards, these must precede any non-flag arguments.
# Exits with error code and error message if an unnacceptable flag was given.
$quiet = $false
$debug = $false
$reveal = $false
$nonFlagOffset = 0
while (($args.count -gt $nonFlagOffset) -and (($args[$nonFlagOffset])[0] -eq '-')) {
	$arg = $args[$nonFlagOffset]
	if ($arg -eq "-q") {
		Write-Host "Quiet = on"
		$quiet = $true
	}
 else {
		if ($arg -eq "-d") {
			if (!$quiet) {
				Write-Host "Debug = on"
			}
			$debug = $true
		}
		else {
			if ($arg -eq "-u") {
				$reveal = $true
			}
			else {
				if (!$quiet) {
					Write-Host "Flag '$arg' not valid for Hide-File command."
				}
				return 1
			}
		}
 }
	$nonFlagOffset = $nonFlagOffset + 1
}

# If debugging: Print the remaining arguments
if ($debug) {
	Write-Host "$($args.count) arguments."
	Write-Host "Non-flag arguments start at index ${nonFlagOffset}:"
	for ($i = $nonFlagOffset; $i -lt $args.count; $i = $i + 1) {
		$file = Get-Item -Force $args[$i]
		if ($null -eq $file) {
			continue
		}
		Write-Host "$file"
	}
}

# Exit with error code and error message if no non-flag arguments were given.
if ($args.count -le $nonFlagOffset) {
	if (!$quiet) {
		Write-Host "No (non-flag) arguments given."
	}
	return 1;
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

if ($reveal -eq $true) {
	for ($i = $nonFlagOffset; $i -lt $args.count; $i = $i + 1) {
		$name = $args[$i]
		$file = Get-Item -Force -ErrorAction SilentlyContinue $name
		if ($null -eq $file) {
			Write-Host "$file is either a system file, not hidden, or not a file at all."
			continue
		}
		$attributes = $file.Attributes -split ", "
		Write-Debug "${file} attributes before: ${file.Attributes}"
		$file.Attributes = Remove-Attribute $attributes "Hidden"
		Write-Debug "${file} attributes after: ${file.Attributes}"
	}
	Exit 0
}

for ($i = $nonFlagOffset; $i -lt $args.count; $i = $i + 1) {
	$name = $args[$i]
	$file = Get-Item -ErrorAction SilentlyContinue $name
	if ($null -eq $file) {
		$file = Get-item -Force -ErrorAction SilentlyContinue $name
		if (!($null -eq $file)) {
			Write-Host "$file is either already hidden, a system file, or not a file at all."
		}
		else {
			Write-Host "Could not find ${name}."
		}
		continue
	}
	# .Attributes is a string for some insane reason (seriously, wtf Microsoft?), so we make it into an array
	$attributes = $file.Attributes -split ", "
	Write-Debug "${file} attributes before: ${attributes}"
	$file.Attributes = Set-Attribute $attributes "Hidden"
	Write-Debug "${file} attributes after: $($file.attributes)"
}
