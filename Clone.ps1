param (
    [Parameter(Mandatory)][string]$url
)

if ([String]::IsNullOrWhitespace($url)) {
    Write-Error "Must provide a valid URL."
    Exit 1
}

$base = $url.TrimEnd("/")
$base = [System.IO.Path]::GetFileNameWithoutExtension($base)

if (!$url.StartsWith("https://")) {
    $url = "https://$url"
}

git clone $url
cd $base
