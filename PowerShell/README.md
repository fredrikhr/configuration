# PowerShell User Profile

PowerShell uses a profile home folder using the `$PSHome` variable inside a
PowerShell console.

## Windows

``` bat
IF EXIST "%USERPROFILE%\Documents\WindowsPowerShell" RENAME "%USERPROFILE%\Documents\WindowsPowerShell" "WindowsPowerShell.bak"
MKLINK /J "%USERPROFILE%\Documents\WindowsPowerShell" "%APPDATA%\Configuration Repository\PowerShell"
IF EXIST "%USERPROFILE%\Documents\WindowsPowerShell.bak" (
  XCOPY /S "%USERPROFILE%\Documents\WindowsPowerShell.bak" "%USERPROFILE%\Documents\WindowsPowerShell"
  RD /S /Q "%USERPROFILE%\Documents\WindowsPowerShell.bak"
)
```

## Linux

``` sh
mkdir -p ~/Documents
ln -sv ~/.config/repository/PowerShell ~/Documents/PowerShell
```

## Custom Prompt

`profile.ps1` contains a custom `prompt` function. It is a copy of the default
PowerShell `prompt` function, but it writes the prompting `>` on a new line
which improves readability when the current path is long.
