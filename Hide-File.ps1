# Exit with error code and error message if no arguments given.
if ($args.count -eq 0) {
	Write-Host "No arguments given."
	return 1
}

# Parses flag arguments.
# As per POSIX standards, these must precede any non-flag arguments.
# Exits with error code and error message if an unnacceptable flag was given.
$quiet = false
$debug = false
$nonFlagOffset = 0
while (($args.count -gt $nonFlagOffset) -and (($args[$nonFlagOffset])[0] -eq '-')) {
	$arg = $args[$nonFlagOffset]
	if ($arg -eq "-q") {
		Write-Host "Quiet = on"
		$quiet = true
	} else { if ($arg -eq "-d") {
		if (!$quiet) {
			Write-Host "Debug = on"
		}
		$debug = true
	}} else {
		if (!$quiet) {
			Write-Host "Flag $arg not valid for Hide-File command."
		}
		return 1
	}
	$nonFlagOffset = $nonFlagOffset + 1
}

# If debugging: Print the remaining arguments
if ($debug) {
	Write-Host "$($args.count) arguments."
	Write-Host "Non-flag arguments start at index ${nonFlagOffset}:"
	for ($i = $nonFlagOffset; $i -lt $args.count; $i = $i + 1) {
		$file = Get-Item -File $args[$i]
		if ($file -eq $null) {
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

function Contains-Value {
	param (
		[Parameter(Mandatory)]
		[Object[]]$Array,

		[Parameter(Mandatory)]
		[Object[]]$Value
	)

	foreach ($element in $Array) {
		if ($element -eq $Value) {
			return true
		}
	}
	return false
}

function Set-Attribute {
	param (
		[Parameter(Mandatory)]
		[System.IO.FileAttributes[]]$AttributeList,

		[Parameter(Mandatory)]
		[System.IO.FileAttributes]$NewAttribute
	)

	$contains = Contains-Value $AttributeList $NewAttribute

	if (!$contains) {
		$AttributeList += $NewAttribute
	}
	return $AttributeList
}

for ($i = $nonFlagOffset; $i -lt $args.count; $i = $i + 1) {
	$name = $args[$i]
	$file = Get-Item -ErrorAction SilentlyContinue $name
	if ($file -eq $null) {
		$file = Get-item -Force -ErrorAction SilentlyContinue $name
		if (!($file -eq $null)) {
			Write-Host "$file is either already hidden, a system file, or not a file at all."
		} else {
			Write-Host "Could not find ${name}."
		}
		continue
	}
	$attributes = $file.Attributes
	Write-Debug "${file} attributes before: ${attributes}"
	$file.Attributes = Set-Attribute $attributes "Hidden"
	Write-Debug "${file} attributes after: $($file.attributes)"
}
