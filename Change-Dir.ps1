<#
.SYNOPSIS
Set the location of the shell. Arguments are joined into a single string,
such that `cd a b` is equivalent to `cd "a b"`.
.DESCRIPTION
Set the location of the shell. Arguments are joined into a single string,
such that `cd a b` is equivalent to `cd "a b"`.

`cd ..` works as normal.
Use `cd -` to go to last location.
Use `cd +` to go forward in history.
#>

param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true
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

if ($loc -eq "." -or [String]::IsNullOrWhiteSpace($loc)) {
    exit 0
}

$before = $pwd.Path.Clone()

if ($loc -eq "-") {
    Push-Location -Path $before -StackName "secondary"
    Pop-Location -StackName "primary" *> $null
    if ($?) {
        $here = (Get-Location).Path.ToString()
        if ($before -ne $here) {
            #Push-Location -Path $before -StackName "secondary"
            Set-Location -StackName ""
            Set-Location $here
        }
    }
    else {
        Pop-Location -StackName "secondary"
        Write-Host "End of stack reached."
    }
    exit 0
}

if ($loc -eq "+") {
    Push-Location -Path $before -StackName "primary"
    Pop-Location -StackName "secondary" *> $null
    if ($?) {
        $here = (Get-Location).Path.ToString()
        if ($before -ne $here) {
            #Push-Location -Path $before -StackName "primary"
            Set-Location -StackName ""
            Set-Location $here
        }
    }
    else {
        Pop-Location -StackName "primary"
        Write-Host "End of stack reached."
    }
    exit 0
}

if ($loc -eq "..") {
    $loc = $before;
}

if (![System.IO.Path]::IsPathRooted($loc)) {
    $dir = [System.IO.Path]::GetFullPath($before)
    $loc = "$dir$sep$loc"
}
# Avoid adding duplicate to the stack.
if ($before.ToUpper() -eq $loc.ToString().ToUpper()) {
    exit 0
}

Pop-Location -StackName "secondary" *> $null
while ($?) {
    Pop-Location -StackName "secondary" *> $null
}
Set-Location -StackName "" *> $null
Set-Location -Path $before

Push-Location -Path $loc -StackName "primary"
if (!$?) {
    Pop-Location -StackName "primary"
}