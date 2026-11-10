param (
    [Parameter(
        Mandatory = $true
    )][string]$suffix,
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true
    )][string[]]$value
)

process {
    for ($i = 0; $i -lt $value.Length; $i++) {
        $foundAt = $value[$i].LastIndexOf($suffix)
        if ($foundAt -ge 0) {
            $value[$i] = $value[$i].Substring(0, $foundAt)
        }
    }
    return $value
}