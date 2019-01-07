COPY "%APPDATA%\Configuration Repository\Git\Home.windows.gitconfig" "%USERPROFILE%\.gitconfig"
ECHO.[user]>"%APPDATA%\Configuration Repository\Git\git-user.gitconfig"
ECHO.    name = %USERNAME%>>"%APPDATA%\Configuration Repository\Git\git-user.gitconfig"
ECHO.    email = %USERNAME%@%COMPUTERNAME%>>"%APPDATA%\Configuration Repository\Git\git-user.gitconfig"