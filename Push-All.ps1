# Pushes the current commit(s) to each registered remote repository.
# Short-circuits on error.

$opts = @{}
foreach ($arg in $args) {
    $arg = "${arg}".TrimStart('-').Trim().ToLower()
    $opts.Add("${arg}", $true)
}

$remotes = git remote show
if ($remotes.Count -eq 0) {
    if (!$opts["quiet"]) {
        Write-Error "This repository has no remotes."
    }
    exit 1
}

foreach ($remote in $remotes) {
    if (!$opts["quiet"]) {
        Write-Host "Pushing to ${remote}..."
    }
    git push $remote
    
    if ($? -eq $false) {
        exit 1
    }
}
exit 0