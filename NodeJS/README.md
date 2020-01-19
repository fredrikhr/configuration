# Node.js, npm and yarn

The `npm` package manager for Node.js usually installs node-applications in a system binary directory when the `--global` flag is passed. The `yarn global` command uses the same settings as `npm`.

## Windows

Although the Node.js installer does register Node.js in the PATH variables (both system-wide and NPM for each user), I like to instead install the Node.js PATH registrations all in the system-wide configuration as follows in the following order.

``` txt
%APPDATA%\npm
%LOCALAPPDATA%\Yarn\bin
C:\Program Files\nodejs\
C:\Program Files (x86)\Yarn\bin\
```

*Note: The paths above assume default install directories.*

## Linux

In order to allow users to install global npm-packages without administrative priviliges, we can set the prefix-configuration for NPM to point to a user-local directory.

The `npm-global.sh` script accomplishes this automatically. If copied to the system profile include directory, global npm-packages are enabled for all users automatically.

You can also enable bash-completion by adding the npm-completion to the system-wide bash completion folder.

``` sh
sudo cp -fv ~/.config/repository/NodeJS/npm-global.sh /etc/profile.d/npm-global.sh \
&& sudo cp -fv ~/.config/repository/NodeJS/npm-completion.sh /etc/bash_completion.d/npm-completion.sh
```
