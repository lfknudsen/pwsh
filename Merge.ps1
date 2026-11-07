<#
.SYNOPSIS
Joins multiple strings together, placing the first argument between them.
.DESCRIPTION
Joins multiple strings together.
First argument is the string to place between each element.
Subsequent arguments are the strings to join.
#>
return [System.String]::Join($args[0], $args[1..($args.count - 1)])