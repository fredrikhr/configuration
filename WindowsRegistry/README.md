# Windows Command Prompt

I like to set common PATHs located in the User directories (like `%APPDATA%`) in
the machine-wide PATH. However, this can lead to issues when a user logs in and
sometimes Windows will not expand the user variables in the PATH.

As a workaround, a PowerShell script can be added to the Autostart and be executed whenever a user logs in. This script simply broadcasts the `WM_SETTINGCHANGE` message, causing Windows to reload the registry and re-evaluating expand-strings in the PATH variable.

## Administrative Command Prompt

``` cmd
MD C:\ProgramData\WM_SETTINGCHANGE
COPY /Y "%APPDATA%\Configuration Repository\WindowsRegistry\WM_SETTINGCHANGE.Broadcast.ps1" C:\ProgramData\WM_SETTINGCHANGE\broadcast.ps1
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "Update Registry" /t REG_SZ /d "powershell.exe C:\ProgramData\WM_SETTINGCHANGE\broadcast.ps1"
```

## Unprivileged Command Prompt

If you do not have administrative privileges, you can enable the same behaviour
by executing the following commands instead:

``` cmd
MD "%APPDATA%\WM_SETTINGCHANGE"
COPY /Y "%APPDATA%\Configuration Repository\WindowsRegistry\WM_SETTINGCHANGE.Broadcast.ps1" "%APPDATA%\WM_SETTINGCHANGE\broadcast.ps1"
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "Update Registry" /t REG_SZ /d "powershell.exe ^"%APPDATA%\WM_SETTINGCHANGE\broadcast.ps1^""
```
