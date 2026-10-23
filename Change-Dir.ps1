if ($Args.Count -eq 0) {
    Exit-PSHostProcess(1);
}
$loc = $Args[0];
if (!($Args.Count -eq 1)) {
    $loc = [String]::Join(" ", $Args);
}
if ($loc -eq "..") {
    $current = Get-Location;
    $loc = [System.IO.Path]::GetDirectoryName($current);
}
Set-Location -Path $loc