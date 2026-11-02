foreach ($arg in $args) {
    New-Item -Type directory -Name $arg > $Null
}