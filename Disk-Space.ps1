Get-WmiObject -Class Win32_LogicalDisk -ComputerName LOCALHOST `
| Where-Object { $_. DriveType -eq 3 } `
| Select-Object @{
    Label      = "Disk"
    Expression = { $_.DeviceID }
}, @{
    Label      = "Total size"
    Expression = { [Math]::Round([float]($_.Size / 1.00GB), 2) }
},
@{
    Label      = "Free space"
    Expression = { [Math]::Round([float]($_.FreeSpace / 1.00GB), 2) }
}