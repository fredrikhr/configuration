# PowerShell User Profile

PowerShell uses a profile file inside a PowerShell console.

For PowerShell distributed on Windows this file is `%USERPROFILE%\Documents\WindowsPowerShell\profile.ps1`.

For PowerShell Core this file is `~/.config/powershell/Microsoft.PowerShell_profile.ps1` (Linux) or `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (Windows)

## Windows

``` bat
MKLINK /J "%USERPROFILE%\Documents\WindowsPowerShell" "%APPDATA%\Configuration Repository\PowerShell"
MKLINK /J "%USERPROFILE%\Documents\PowerShell" "%APPDATA%\Configuration Repository\PowerShell"
COPY /Y "%APPDATA%\Configuration Repository\PowerShell\profile.ps1" "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
```

## Linux

``` sh
ln -sfv ~/.config/repository/PowerShell ~/.config/powershell
ln -sfv ~/.config/repository/PowerShell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
```

## Custom Prompt

`prompt.ps1` contains a custom `prompt` function. It is a copy of the default
PowerShell `prompt` function, but it writes the prompting `>` on a new line
which improves readability when the current path is long.
