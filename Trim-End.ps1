param (
    [Parameter(
        Mandatory=$false
    )][string]$chars,
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )][string[]]$value
)

process {
    foreach ($val in $value) {
        if ($val -eq "") {
            Write-Output $val
        } elseif ($chars -eq "") {
            Write-Output $val.TrimEnd()
        } else {
            Write-Output $val.TrimEnd($chars)
        }
    }
}