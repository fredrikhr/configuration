# PowerShell User Profile

PowerShell uses a profile file inside a PowerShell console.

For PowerShell distributed on Windows this file is `%USERPROFILE%\Documents\WindowsPowerShell\profile.ps1`.

For PowerShell Core this file is `~/.config/powershell/Microsoft.PowerShell_profile.ps1` (Linux) or `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (Windows)

## Windows

``` bat
dotnet tool install --global dotnet-suggest
MKLINK /J "%USERPROFILE%\Documents\WindowsPowerShell" "%APPDATA%\Configuration Repository\PowerShell"
MKLINK /J "%USERPROFILE%\Documents\PowerShell" "%APPDATA%\Configuration Repository\PowerShell"
COPY /Y "%APPDATA%\Configuration Repository\PowerShell\profile.ps1" "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
curl -LRJ -o "%APPDATA%\Configuration Repository\PowerShell\ps1.d\dotnet-suggest-shim.ps1" "https://github.com/dotnet/command-line-api/raw/master/src/System.CommandLine.Suggest/dotnet-suggest-shim.ps1"
```

## Linux

``` sh
dotnet tool install --global dotnet-suggest
ln -sv ~/.config/repository/PowerShell ~/.config/powershell
cp -fv ~/.config/repository/PowerShell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
curl -LRJ -o "~/.config/repository/PowerShell/ps1.d/dotnet-suggest-shim.ps1" "https://github.com/dotnet/command-line-api/raw/master/src/System.CommandLine.Suggest/dotnet-suggest-shim.ps1"
sudo curl -LRJ -o /etc/bash_competion.d/dotnet-suggest-shim.bash "https://github.com/dotnet/command-line-api/raw/master/src/System.CommandLine.Suggest/dotnet-suggest-shim.bash"
```

## Custom Prompt

`prompt.ps1` contains a custom `prompt` function. It is a copy of the default
PowerShell `prompt` function, but it writes the prompting `>` on a new line
which improves readability when the current path is long.
