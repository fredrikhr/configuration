# Bash configuration

Similar to the [PowerShell](../PowerShell/README.md) configuration, I like to display an extra newline on the prompt of my shell, as it improves readability if the current working directory is a long path.

## Setup

Even though a little counter-intuitive, the prompt script is added to system-wide `bash_completion.d` folder. This folder is included **after** the user-local `.bashrc` is sourced, so setting the `PS1` variable is safe when placed in `bash_completion.d`.

```bash
sudo ln -sv /etc/bash_completion.d/prompt-new-line.bash ~/.config/repository/Bash/prompt-new-line.bash
```