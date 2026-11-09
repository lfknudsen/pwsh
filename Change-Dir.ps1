<#
.SYNOPSIS
Set the location of the shell. Arguments are joined into a single string,
such that `cd a b` is equivalent to `cd "a b"`.
.DESCRIPTION
Set the location of the shell. Arguments are joined into a single string,
such that `cd a b` is equivalent to `cd "a b"`.
#>

param (
    [Parameter(
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromRemainingArguments=$true
    )
    ][Object[]]$Args
)

if ($Args.Count -eq 0) {
    return
}
$loc = $Args[0];
if (!($Args.Count -eq 1)) {
    $loc = [String]::Join(" ", $Args);
}

if ($loc -eq "-") {
    Pop-Location
    exit 0
}

if ($loc -eq "..") {
    $current = Get-Location;
    $loc = [System.IO.Path]::GetDirectoryName($current);
}
Push-Location -Path $loc