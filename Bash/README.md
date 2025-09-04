# Bash configuration

By default bash looks for a user profile local file called `~/.bash_aliases`.
Usually this file is reserved for creating aliases for your local bash session.
I have chosen to extend the default behaviour of putting files into .d folder.
The `bash-aliases.bash` file causes bash to look for a folder `~/.bashrc.d` and
dots (`.`) all files within that folder. That way, users with no sudo access
can put their configurations into that folder instead.

Similar to the [PowerShell](../PowerShell/README.md) configuration, I like to display an extra newline on the prompt of my shell, as it improves readability if the current working directory is a long path.

## Setup

Even though a little counter-intuitive, the prompt script is added to system-wide `bash_completion.d` folder. This folder is included **after** the user-local `.bashrc` is sourced, so setting the `PS1` variable is safe when placed in `bash_completion.d`.

```bash
sudo cp -fv ~/.config/repository/Bash/prompt-new-line.bash /etc/bash_completion.d/prompt-new-line.bash && \
ln -sfv ~/.config/repository/Bash/bash-aliases.bash ~/.bash_aliases && \
mkdir -p ~/.bashrc.d && ln -sfv ~/.config/repository/Bash/bash-completion.sh ~/.bashrc.d/bash-completion.sh
```
