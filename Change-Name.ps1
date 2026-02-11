#Requires -version 5.1

$help = "Change-Name [Options] <from> <to>
	Creates a copy of the file given in <from>, giving it the name
	<to>, but keeping the old filetype and path.
	
	If there is a wildcard in <from> but not <to>, this script will
	work on each matched file, replacing the expanded part of the filename
	with <to>.
	If there is a wildcard in <to>, this script will
	replace the asterisk with the filename (excl. extension) of
	(any files matched by) <from>.

	Options:
	All flags are case-insensitive.
	Only the single leading dash is required. Any other dashes/underscores
	anywhere in a flag will be ignored.

		-d		
		--dry-run	Perform a dry run without making any changes.

		-m		
		--move		Move the file instead of making a copy.
				You will be asked to confirm any deletions.

		-f		
		--force		Do not ask the user to confirm before
				deleting any files.

		-c
		--confirm	Asks the user for confirmation before each
				change.
		
		-h		
		--help		Print this text and exit.


	Examples:
		Change-Name text.txt text2
			would output
		text2.txt

		Change-Name text.txt text2.txt
			would output
		text2.txt.txt

		Change-Name subdir/text.txt text2
			would output
		subdir/text2.txt

		Change-Name subdir/*-a.txt *-b
			which matches the files
				subdir/1-a.txt
				subdir/2-a.txt
			would output
		subdir/1-a-b.txt
		subdir/2-a-b.txt

		Change-Name subdir/a.txt *-b
			would output
		subdir/a-b.txt

		Change-Name subdir/a.txt subsub/b.txt
			would output
		subdir/subsub/b.txt"

# Hash table of options. The values will be mutated when parsing arguments.
$opts = @{h = $false; d = $false; m = $false; f = $false; c = false}

# Maps long-form option names to their short-hand.
$longToShort = @{"help" = "h"; "dryrun" = "d"; "move" = "m"; "force" = "f"; "confirm" = "c"}

# Print the $help string, and exit with code 0:
function Show-Help {
	Write-Host $help
	exit 0
}

# Returns whether the given argument string should be parsed as an options flag,
# based on whether it has several characters and starts with a dash.
function Is-Flag {
	param (
		[Parameter(Mandatory)]
		[string]$arg
	)
	
	($arg.length -gt 1) -and ($arg[0] -eq '-')
}

# Returns the index of the first character in 'arg' that isn't equal to 'skipped'.
function Skip-Character {
	param (
		[Parameter(Mandatory)]
		[string]$arg,

		[Parameter(Mandatory)]
		[string]$skipped
	)

	for ($i = 0; $i -lt $arg.length; $i = $i + 1) {
		if (!($arg[$i] -eq $skipped)) {
			return $i
		}
	}
	return 0
}

# Transforms an argument string into a (hopefully valid) flag.
function Get-Initial {
	param (
		[Parameter(Mandatory)]
		[string]$arg
	)

	if ($arg.length -gt 2) {
		$sub = $arg -replace "[-_]", ""
		Write-Debug "The argument ${arg} became ${sub}."
		return $longToShort.Item($sub.toLower())
	} else {
		return "$($arg[1])".toLower()
	}
}

# Returns the index of the first occurrence of 'character' in 'arg'.
function Find-Character {
	param (
		[Parameter(Mandatory)]
		[string]$arg,

		[Parameter(Mandatory)]
		[string]$character
	)

	for ($i = 0; $i -lt $arg.length; $i = $i + 1) {
		if ($arg[$i] -eq $character) {
			return $i
		}
	}
	return -1
}

# Parses the input option arguments and returns the index of the first non-flag argument.
# Reads $args and reads/writes $opts.
function Set-Options {
	param (
		[Parameter(Mandatory)]
		[string[]]$args
	)

	Write-Debug "Parsing input arguments."

	$i = 0
	while ($i -lt $args.count) {
		$arg = $args[$i]
		Write-Debug "Parsing '${arg}'."
		# If not a flag (meaning if it doesn't begin with a dash),
		# break so that we can proceed to parse non-flag arguments.
		if (!(Is-Flag $arg)) {
			Write-Debug "${arg} was not a flag."
			break
		}

		# Update table of options if the inital was found.
		$flag = Get-Initial $arg
		if ($flag -eq $null) {
			Write-Host "Option ${arg} not recognised. Execute Change-Name -h for more details."
			exit 1
		}
		if (!($opts.Item($flag) -eq $null)) {
			$opts.Item($flag) = $true
		} else {
			Write-Host "Option ${arg} not recognised. Execute Change-Name -h for more details."
			exit 1
		}
		$i = $i + 1
	}
	return $i
}

function Assert-NonEmpty {
	param (
		[Parameter(Mandatory, Position = 0)]
		[string]$firstArg,

		[Parameter(Mandatory, Position = 1)]
		[string]$firstArgName
	)

	if ($firstArg -eq "") {
		Write-Host "${firstArgName} is an empty string."
		exit 1
	}
}

# Print what the subsequent list of actions will entail.
function Write-Action {
	param (
		[Parameter(Mandatory)]
		$filesFound
	)
	
	$action = ""
	if ($opts["d"]) {
		$action = "Dry run. "
	}
	if ($opts["m"]) {
		if ($opts["f"]) {
			$action = "${action}Forcefully moving"
		} else {
			$action = "${action}Moving"
		}
	} else {
		$action = "${action}Copying"
	}

	# Append number of files changed.
	$action = "${action} ${filesFound} file"
	if ($in.count -gt 1) {
		$action = "${action}s."
	} else {
		$action = "${action}."
	}

	Write-Host "${action}"
}

# If <to> has an asterisk, replace it with the input file name.
# Otherwise, just set the output name to equal <to>.
function New-Name {
	param (
		[Parameter(Mandatory)]
		[string]$to,

		[Parameter(Mandatory)]
		[string]$old_name
	)
	$wildcard_to = Find-Character $to_name '*'
	if ($wildcard_to -ge 0) {
		$prefix = $to_name.substring(0, $wildcard_to)
		$suffix = ""
		if ($wildcard -lt ($to_name.length - 1)) {
			$suffix = $to_name.substring($wildcard_to + 1)
		}
		return "${prefix}${old_name}${suffix}"
	} else {
		return "${to}"
	}

}

function Update-Directories {
	param (
		[Parameter(Mandatory)]
		[bool]$must_create_subdirs,

		[Parameter(Mandatory)]
		[string]$to_dir
	)

	# Ensure any subdirectories have been created.
	if ($must_create_subdirs) {
		New-Item -ItemType Directory -Force $to_dir | Out-Null
	}
}

function Update-File {
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory)]
		[string]$path,

		[Parameter(Mandatory)]
		[string]$out
	)

	Write-Debug "[Update-File] Path: $path"
	Write-Debug "[Update-File] Out: $out"

	# ONLY continue if this is not a dry-run
	if (!($opts["d"])) {
		# Set any secondary arguments.
		$force = ""
		if ($opts["f"]) {
			$force = "-Force"
		}
		$confirm = ""
		if ($opts["c"]) {
			$confirm = "-Confirm"
		}

		if (Test-Path $out) {
			$shouldOverwrite = $PSCmdlet.ShouldProcess("This action will overwrite the existing ${out} with the contents of ${path}.",
				"Should the existing ${out} be replaced?",
				"${out} already exists.")
			if (!$shouldOverwrite) {
				Write-Host "Skipping ${path}."
				continue
			}
		}

		if ($opts["m"]) {
			if ($opts["f"]) {
				if ($opts["c"]) {
					Move-Item -Force -Confirm -Path $path -Destination $out
				} else {
					Move-item -Force -Path $path -Destination $out
				}
			} else {
				Move-Item -Path $path -Destination $out
			}
		} else {
			if ($opts["c"]) {
				Copy-Item -Confirm -Path $path -Destination $out
			} else {
				Copy-Item -Path $path -Destination $out
			}
		}
	}
}

### ENTRY POINT ###

# If only argument is -h or --help, print options and exit with code 0.
if ($args.count -gt 0) {
	$first_arg = $args[0].toLower()
	if (($first_arg -eq "-h") -or ($first_arg -eq "--help")) {
		Show-Help
	}
} else {
	Show-Help
}

# If fewer than the minimum required arguments, print error message and exit with code 1.
if ($args.count -lt 2) {
	Write-Host "Too few arguments. Execute Change-Name -h for more details."
	exit 1
}

# Iterate through arguments until non-flag argument is reached.
$i = Set-Options $args

if ($opts["h"]) {
	Show-Help
}

# If user has not supplied both <from> and <to>, exit with code 1.
if (($args.count - $i) -lt 2) {
	Write-Host "Too few arguments following the options. Execute Change-Name -h for more details."
	exit 1
}

$from = $args[$i]
$to = $args[$i + 1]

Assert-NonEmpty $from "Input name"
Assert-NonEmpty $to "Output name"

# Get the file(s) matching the text in <from>.
$in = Get-Item $from
if ($in.count -eq 0) {
	Write-Host "The file '${from}' could not be found."
	exit 1
}

Write-Action $in.count

$to_name = [System.IO.Path]::GetFileName($to)
$parts = $to_name.split("*")
if ($parts.count -gt 2) {
	Write-Host "There were multiple wildcard (*) characters in the output filename pattern."
	exit 1
}

# Perform actual renaming.
for ($i = 0; $i -lt $in.count; $i = $i + 1) {
	$path = $in[$i].FullName
	$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
	$ext = [System.IO.Path]::GetExtension($path)
	$dir = [System.IO.Path]::GetDirectoryName($path)

	# Determine the new name.
	if ($parts.count -eq 1) {
		$out = "${out}${ext}"
	} else {
		$out = "$($parts[0])${name}$($parts[1])${ext}"
	}

	# Join any subdirectories specified in <to> with the output filename.
	$to_dir = [System.IO.Path]::GetDirectoryName($to)
	$must_create_subdirs = !($to_dir -eq "")
	if ($must_create_subdirs) {
		$dir = [System.IO.Path]::Combine($dir, $to_dir)
	}

	# Join the original file's directory path with the output filename.
	$out = [System.IO.Path]::Combine($dir, $out)
	
	# Write the fully-qualified name of the input file and output file.
	Write-Host "$($i + 1)	$($path)	->	$($out)"
	if (!$opts["d"]) {
		Update-Directories $must_create_subdirs $dir
		Update-File $path $out
	}
}
