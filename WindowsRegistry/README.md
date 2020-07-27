# Windows Command Prompt

I like to set common PATHs located in the User directories (like `%APPDATA%`) in
the machine-wide PATH. However, this can lead to issues when a user logs in and
sometimes Windows will not expand the user variables in the PATH.

As a workaround, a `WM_SETTINGCHANGE` broadcast message can be issued whenever a users logs in, causing Windows to reload the registry and re-evaluating expand-strings in the PATH variable.

## Administrative Command Prompt

``` cmd
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "Update Registry" /t REG_SZ /d "rundll32.exe user32.dll,UpdatePerUserSystemParameters 1 True"
```

## Unprivileged Command Prompt

If you do not have administrative privileges, you can enable the same behaviour
by executing the following commands instead:

``` cmd
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "Update Registry" /t REG_SZ /d "rundll32.exe user32.dll,UpdatePerUserSystemParameters 1 True"
```
