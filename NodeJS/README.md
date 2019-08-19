# Node.js, npm and yarn

The `npm` package manager for Node.js usually installs node-applications in a system binary directory when the `--global` flag is passed. The `yarn global` command uses the same settings as `npm`.

## Linux

In order to allow users to install global npm-packages without administrative priviliges, we can set the prefix-configuration for NPM to point to a user-local directory.

The `npm-global.sh` script accomplishes this automatically. If copied to the system profile include directory, global npm-packages are enabled for all users automatically.

You can also enable bash-completion by adding the npm-completion to the system-wide bash completion folder.

``` sh
sudo cp -fv ~/.config/repository/NodeJS/npm-global.sh /etc/profile.d/npm-global.sh
echo "source <(npm completion)" | sudo dd of=/etc/bash_completion.d/npm
```
