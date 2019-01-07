REM Delete existing VsCode Configuration Folder
RD /S /Q "%APPDATA%\Code\User"
MD "%APPDATA%\Code"
MKLINK /J "%APPDATA%\Code\User" "%APPDATA%\Configuration Repository\VsCode"
