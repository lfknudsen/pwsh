<#
.SYNOPSIS
Outputs a string consisting of the second argument repeated an amount of times equal
to the first argument.
.DESCRIPTION
Outputs a string consisting of <string> repeated <n> times:

Repeat <n> <string>
#>

$output = ""
for ($i = 0; $i -lt $args[0]; $i++) {
    $output += $args[1]
}
return $output