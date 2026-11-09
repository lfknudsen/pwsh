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
    exit 1
}
$loc = $Args[0];
if (!($Args.Count -eq 1)) {
    $loc = [String]::Join(" ", $Args);
}

if ($loc -eq "-") {
    Push-Location -Path $pwd -StackName "secondary"
    Pop-Location -StackName ""
    exit 0
}

if ($loc -eq "+") {
    Pop-Location -StackName "secondary" *> $null
    exit 0
}

if ($loc -eq "..") {
    $current = Get-Location;
    $loc = [System.IO.Path]::GetDirectoryName($current);
}

Pop-Location -StackName "secondary" *> $null
while ($?) {
    Pop-Location -StackName "secondary" *> $null
}

Push-Location -Path $loc -StackName ""