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

## Hide-File

Does what it says on the tin. I don't remember when I wrote this.

## Change-Name

Batch renaming of files not affecting their extensions. I don't remember when I wrote this.
