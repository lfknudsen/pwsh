# PWSH - Powershell Commands

Shell scripts I use. Each header below shows the script name followed\
by what I personally alias it to.

See [this repository](https://gitlab.com/lfknudsen/pwsh-config) for my config file.

## Change-Dir (cd)

Automatically transforms multiple inputs into one, so that\
`cd new location` is instead understood as `cd "new location"`.

```
cd <sub directory>
```

I recommend aliasing this to `cd` in your $profile file.

## goto

If the input path is a file, this command will `cd` to its directory.
If the input path is a directory, this command will just `cd` there directly.

```
goto <file name|directory name>
```

Example to go to the same directory as your PowerShell config file:
```
goto $profile
```


## New-Dir (ndir)

Creates a new directory with the given name and then enters it.\
Also omits the huge stdout statement PowerShell normally gives `mkdir`.

```
ndir <new dir name>
```

I personally alias this to `ndir`.

## Make-Dirs (mkdirs)

Creates multiple sub-directories at once.\
I alias this to `mkdirs`.

```
mkdirs <new dir name>...
```

## Disk-Space (space)

Displays the total and remaining disk space on each drive.\
Almost certainly Windows exclusive.

## Open-Env (path)

Opens the dialog window for adding new environment variables.\
Almost certainly Windows exclusive.\

## Push-All

Executes `git push` on each remote registered in the current git repository.\
See [push](https://gitlab.com/lfknudsen/push) for a slightly more feature-rich, natively compiled version I wrote later.

## Hide-File (hide)

Adds the 'Hidden' attribute to the given file(s). I'm not sure I've ever used this;
I may have originally just written it as an experiment. Since refactoring it and fixing some issues it had, I alias this to `hide`.

```
hide [-u] <files...>
```

If supplied with `-u` will reveal the file(s) instead.

## Reveal-File (reveal, unhide)

Removes the 'Hidden' attribute from the given file(s). I wrote this when refactoring Hide-File.ps1.
I alias this to `reveal` and `unhide`.

`reveal <file(s)` is equivalent to `hide -u <file(s)>`, but you can only alias a command on its own (i.e. you cannot include -u in the alias value), and as such I decided to make it standalone.


## Change-Name

Batch renaming of files not affecting their extensions. I don't remember when I wrote this, and so it may not have been complete when I decided to make this repo public. Double-check
the code or do a dry run first :)
