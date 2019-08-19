# Ruby & Gem setup for user-install

The `gem` package manager for Ruby supports installation to a user local directory, enabling users to install gems globally without administrative priviliges.

For this to work, the `PATH` environment variable needs to include the `bin`-folder of the gem user directory.

## Linux

Copy the file `ruby-gem-user-dir.sh` to your system `profile.d` folder to enable user-local gems for all users:

``` sh
sudo cp -fv ~/.config/repository/Ruby/ruby-gem-user-dir.sh /etc/profile.d/ruby-gem-user-dir.sh
```
