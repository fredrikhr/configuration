# Git configuration

Configuration for Git Version Control.

## Setup commands

| OS | Command-line |
| - | - |
| Windows | `COPY "%APPDATA%\Configuration Repository\Git\Home.windows.gitconfig" "%USERPROFILE%\.gitconfig"` |
| UNIX | `ln -sfv ~/.config/repository/Git/Home.unix.gitconfig ~/.gitconfig`

### User configuration commands

| OS | Command-line |
| - | - |
| Windows | `COPY "%APPDATA%\Configuration Repository\Git\git-user.sample.gitconfig" "%APPDATA%\Configuration Repository\Git\git-user.gitconfig"` |
| UNIX | `cp -v ~/.config/repository/Git/git-user.sample.gitconfig ~/.config/repository/Git/git-user.gitconfig`

Then open one of the following files in your text editor of choice:

| OS | Command-line |
| - | - |
| Windows | `"%APPDATA%\Configuration Repository\Git\git-user.gitconfig"` |
| UNIX | `~/.config/repository/Git/git-user.gitconfig`

## Git-config include path

The user-specific `.gitconfig` file normally sits in the user's home directory (i.e. `~/.gitconfig` or `%USERPROFILE%\.gitconfig`). In order to keep my Git configuration in the local clone of this repository, I use the `include.path` configuration to point my Home-directory `.gitconfig` file to the actual file in this repository.

| OS | File to use as Home Directory `.gitconfig` |
| - | - |
| Windows | [`Home.windows.gitconfig`](Home.windows.gitconfig) |
| UNIX | [`Home.unix.gitconfig`](Home.unix.gitconfig) |

## Git push default configuration

I sometimes do Open-Source development with multiple remotes in a single repository (`origin` and my personal fork) and I like to prefix my local branches which do not track origin with the name of the remote. On the upstream repository (e.g. on GitHub) I do not need the prefix anymore.

| Local Branch | Remote-tracking Branch |
| - | - |
| `master` | `origin/master` |
| `fredrikhr-master` | `fredrikhr/master` |
| `fredrikhr-feature` | `fredrikhr/feature` |

This is a problem if you do not configure your default push settings. Because of that I use the `tracking` setting as defined in [`git-push.gitconfig`](git-push.gitconfig). This will cause git to always push to the branch that is set up as the remote-tracking branch, regardless of differences in naming.

From the third example in the list above I'd **one-time** configure my local branch using the following command:

``` sh
git push -u fredrikhr fredrikhr-feature:feature
```

This will set up the local `fredrikhr-feature` branch to track the `feature` branch one the `fredrikhr` remote.

## Git pretty log command

In my configuration I include `git lg` command aliases for pretty Git log printing. Checkout the [git-lg.gitconfig](git-lg.gitconfig) in this folder.

These command aliases `git lg1` and `git lg2` are a courtesy of [Slipp D. Thompson](https://stackoverflow.com/users/177525/slipp-d-thompson) on the following [StackOverflow answer](https://stackoverflow.com/a/9074343).
