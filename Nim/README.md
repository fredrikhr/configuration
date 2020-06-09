# Nim

When nim is installed, you usually want to expand the PATH to include the
user-local paths to Nimble and Choosenim.

## Windows

``` bat
%USERPROFILE%\.nimble\bin
```

## Linux

``` sh
sudo cp -fv ~/.config/repository/Nim/nimble.sh /etc/profile.d/nimble.sh
sudo cp -fv ~/.config/repository/Nim/choosenim.sh /etc/profile.d/choosenim.sh
```
