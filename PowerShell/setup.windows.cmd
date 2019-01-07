IF EXIST "%USERPROFILE%\Documents\WindowsPowerShell" RENAME "%USERPROFILE%\Documents\WindowsPowerShell" "WindowsPowerShell.bak"
MKLINK /J "%USERPROFILE%\Documents\WindowsPowerShell" "%APPDATA%\Configuration Repository\PowerShell"
IF EXIST "%USERPROFILE%\Documents\WindowsPowerShell.bak" XCOPY /S "%USERPROFILE%\Documents\WindowsPowerShell.bak" "%USERPROFILE%\Documents\WindowsPowerShell"