# Periodically update your clone of this repository

The `repo-update.bash` script is designed to be put into session start-up
script folder, like `~/.bashrc.d/repo-update.bash`. The script checks whether a
touch file has a timestamp older than 7 days (1 week). If so, this repository
is pulled. That way the configuration added by this repo is automatically kept
reasonably up to date.

``` bash
mkdir -p ~/.bashrc.d && ln -sfv ~/.config/repository/Config-Repository-Update/repo-update.bash ~/.bashrc.d/repo-update.bash
```
