<#
.SYNOPSIS
Shows the total size and free space left on each drive in a table.
.DESCRIPTION
Shows the total size and free space left on each drive in a table.
Windows exclusive.
#>

$obj = Get-WmiObject -Class Win32_LogicalDisk -ComputerName LOCALHOST
$obj.Where({$_. DriveType -eq 3}) `
| Format-Table @{
    Label      = "Disk"
    Expression = { $_.DeviceID }
}, @{
    Label      = "Total size"
    # 7 = Label.Count - " GB".Count
    # 2 = 2 decimal places, which is what we round it to
    Expression = { "{0,7:N2} GB" -f [Math]::Round($_.Size / 1.00GB, 2) }
    Alignment="right"
},
@{
    Name      = "Free space"
    # 7 = Label.Count - " GB".Count
    # 2 = 2 decimal places, which is what we round it to
    Expression = { "{0,7:N2} GB" -f [Math]::Round($_.FreeSpace / 1.00GB, 2) }
    Alignment="right"
}