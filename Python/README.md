# Python pip User site packages

`pip`, the Python package manager, support installing packages to a user site directory, enabling a user to install packages without administrative privileges.

In order to be able to execute binaries installed this way, the user site binary directory has to be added to the `PATH` environment variable.

## Windows

For Python installations on Windows, I personally like to not add Python to the PATH variable in the installer and instead add the necessary PATHs manually afterward.

The Python package manager, `pip`, usually installs packages in the Python installation directory. If Python is installed system-wide (for all users), this usually requires administrative privileges. The `pip` command-line has a `--user` option, that allows for installation of packages in the user directories (requiring no administrative privileges). **However, by default the user directories are not included in the `PATH`.**

Additionally, the user directories have different PATHs starting with Python 3.

|Type|`PATH`|
|-|-|
|Python 3.8 User-base|`%APPDATA%\Python\Python38\Scripts`|
|Python 3.8 User-install|`%LOCALAPPDATA%\Programs\Python\Python38`<br/>`%LOCALAPPDATA%\Programs\Python\Python38\Scripts`|
|Python 3.8 System-install|`C:\Program Files\Python38`<br/>`C:\Program Files\Python38\Scripts`|
|Python 2.7 User-base|`%APPDATA%\Python\Scripts`|
|Python 2.7 User-install|`%LOCALAPPDATA%\Programs\Python\Python27`<br/>`%LOCALAPPDATA%\Programs\Python\Python27\Scripts`|
|Python 2.7 System-install|`C:\Program Files\Python27`<br/>`C:\Program Files\Python27\Scripts`|

*Note: The User-base directory for Python 2.7 (and earlier) does **NOT** include the Python version suffix in its path.*

## Linux

``` sh
sudo cp -fv ~/.config/repository/Python/python-user-site.sh /etc/profile.d/python-user-site.sh
```
