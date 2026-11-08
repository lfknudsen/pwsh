<#
.DESCRIPTION
If $path is a directory, cd there.
If $path is a file, go to its directory.
.SYNOPSIS
If $path is a directory, cd there.
If $path is a file, go to its directory.
#>

param (
    [Parameter(Mandatory=$true)][string]$path
)

# Makes "goto .." the same speed as "cd .."
# Pretty pointless, but I've caught myself using "goto .." now and then
if ($path -eq "..") {
    Set-Location ..
    exit
}

# Get absolute path, because otherwise System.IO.File::GetAttributes
# tries to find the file/dir within the default directory.
if (!([System.IO.Path]::IsPathRooted($path))) {
    $sep = [System.IO.Path]::DirectorySeparatorChar
    $path = "$pwd$sep$path"
    $path = [System.IO.Path]::GetFullPath($path)
}

# If the file could not be found, then this will return null.
# We will exit early, so only one error message is displayed.
$attributeString = [System.IO.File]::GetAttributes($path)
if ($null -eq $attributeString) {
    exit 1
}

# GetAttributes probably returned a string, which we convert to an array.
$attributes = $attributeString -split ", "

# A directory entry's attributes are either returned as a comma-separated "list" or an integer,
# so we check it either way.
if ($attributes.Contains("Directory") -or $attributeString -band [System.IO.FileAttributes]::Directory) {
    # Was a directory
    Set-Location $path
} else {
    # Was a file
    $directory = [System.IO.Path]::GetDirectoryName($path)
    Set-Location -Path $directory
}
