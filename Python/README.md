# Python pip User site packages

`pip`, the Python package manager, support installing packages to a user site directory, enabling a user to install packages without administrative privileges.

In order to be able to execute binaries installed this way, the user site binary directory has to be added to the `PATH` environment variable.

## Linux

``` sh
sudo cp -fv ~/.config/repository/Python/python-user-site.sh /etc/profile.d/python-user-site.sh
```
