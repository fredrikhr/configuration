# Ruby & Gem setup for user-install

The `gem` package manager for Ruby supports installation to a user local directory, enabling users to install gems globally without administrative priviliges.

For this to work, the `PATH` environment variable needs to include the `bin`-folder of the gem user directory.

## Inspect

Run the following command to inspect the current user path for the `gem` package manager

``` sh
ruby -r rubygems -e 'puts Gem.user_dir'
```

## Windows

Add the `bin` folder of the Gem user directory to the `PATH`. (Preferably right **before** the entry for the ruby binary.)

``` cmd
%USERPROFILE%\.gem\ruby\2.6.0\bin
```

## Linux

Copy the file `ruby-gem-user-dir.sh` to your system `profile.d` folder to enable user-local gems for all users:

``` sh
sudo cp -fv ~/.config/repository/Ruby/ruby-gem-user-dir.sh /etc/profile.d/ruby-gem-user-dir.sh
```
