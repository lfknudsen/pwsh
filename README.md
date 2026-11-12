# PWSH - Powershell Commands

Shell scripts I use. Each header below shows the script name followed\
by what I personally alias it to. Generally speaking, scripts support
pipeline multi-line pipeline input for batch processing. Any that do not
are an oversight on my part; feel free to open a PR fixing them.

See [this repository](https://gitlab.com/lfknudsen/pwsh-config) for my config file.

## Traversal
### Change-Dir (cd)

Automatically transforms multiple inputs into one, so that\
`cd new location` is instead understood as `cd "new location"`.

```
cd <sub directory>
```

I recommend aliasing this to `cd` in your $profile file.

### goto

If the input path is a file, this command will `cd` to its directory.
If the input path is a directory, this command will just `cd` there directly.

```
goto <file name|directory name>
```

Example to go to the same directory as your PowerShell config file:
```
goto $profile
```

## Directory Management
### New-Dir (ndir)

Creates a new directory with the given name and then enters it.\
Also omits the huge stdout statement PowerShell normally gives `mkdir`.

```
ndir <new dir name>
```

I personally alias this to `ndir`.

### Make-Dirs (mkdirs)

Creates multiple sub-directories at once.\
I alias this to `mkdirs`.

```
mkdirs <new dir name>...
```

## Development
### Push-All

Executes `git push` on each remote registered in the current git repository.\
See [push](https://gitlab.com/lfknudsen/push) for a slightly more feature-rich,
natively compiled version I wrote later.

## Strings
### Cut-Prefix, Cut-Suffix

Cuts the given prefix/suffix from the given string(s) if it is present:

```
Cut-Prefix <prefix> <string>
```

```
Cut-Suffix <suffix> <string>
```

### Trim, Trim-Start, Trim-End

Removes any characters in <chars> from the start/end/both of the string(s):
If no <chars> is given, trims whitespace instead.

```
Trim [<chars>] <string>
Trim-Start [<chars>] <string>
Trim-End [<chars>] <string>
```

### Repeat

Very efficiently creates a string of repeated characters or strings:

```
Repeat <n> <character>
Repeat <n> <string>
```

### Split-On

Splits the input string into an array based on the given delimiter character
(which will not be included in the output). Empty elements are omitted from the
output.

```
Split-On <delimeter> <string>
```

### Merge

Joins together multiple strings, putting <between> in-between.

```
Merge <between> <strings>
```

## File Management

### Disk-Space (space)

Displays the total and remaining disk space on each drive.\
Almost certainly Windows exclusive.
Example:

```
$ space
Disk  Total size Free space
---- ----------- ----------
C:     475.69 GB   41.22 GB
D:   14752.69 GB  987.70 GB
```

### Hide-File (hide)

Adds the 'Hidden' attribute to the given file(s). I'm not sure I've ever used this;
I may have originally just written it as an experiment. Since refactoring it
and fixing some issues it had, I alias this to `hide`.

```
hide [-u] <files...>
```

If supplied with `-u` will reveal the file(s) instead.

### Reveal-File (reveal, unhide)

Removes the 'Hidden' attribute from the given file(s). I wrote this when
refactoring Hide-File.ps1.
I alias this to `reveal` and `unhide`.

`reveal <file(s)` is equivalent to `hide -u <file(s)>`, but you can only alias
a command on its own (i.e. you cannot include -u in the alias value), and as
such I decided to make it standalone.


### Change-Name

Batch renaming of files not affecting their extensions. I don't remember when I
wrote this, and so it may not have been complete when I decided to make this
repo public. Double-check the code or do a dry run first :)

## Environment Variables

### Open-Env (path)

Opens the dialog window for adding new environment variables.\
Almost certainly Windows exclusive.

### Get-Env

Returns the value(s) of the given path(s) as an array:
```
Get-Env <environment variable name(s)>
Get-Env *
```

If given the argument `*`, it will return the values of *all* environment variables.

## CLI

### Alias-Exists

Returns true if the given alias exists.

```
Alias-Exists <alias name>
```

### Remove-Alias

Safe way to remove an alias, which will not throw an exception if the alias
did not exist.

```
Remove-Alias <alias name>
```