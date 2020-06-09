FROM fredrikhr/devcontainer:base-thirdpartydeps-ubuntu-18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN     set -x \
    # Configuration Repository
    &&  git clone --depth 1 https://github.com/fredrikhr/configuration.git -- ~/.config/repository 2>&1

RUN     set -x \
    # Config: Bash
    &&  ln -sfv ~/.config/repository/Bash/bash-aliases.bash ~/.bash_aliases \
    &&  mkdir -p ~/.bashrc.d/ \
    &&  ln -sfv ~/.config/repository/Bash/prompt-new-line.bash ~/.bashrc.d/prompt-new-line.bash \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Git
    &&  ln -sfv ~/.config/repository/Git/Home.unix.gitconfig ~/.gitconfig \
    &&  mkdir -p ~/.local/share/git-credential-manager/ \
    &&  wget -O ~/.local/share/git-credential-manager/git-credential-manager-2.0.4.jar \
            https://github.com/microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.4/git-credential-manager-2.0.4.jar 2>&1 \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Vim
    &&  git clone https://github.com/VundleVim/Vundle.vim.git -- ~/.vim/bundle/Vundle.vim  2>&1 \
    &&  ln -sfv ~/.config/repository/Vim ~/.vim/config \
    &&  ln -sfv ~/.vim/config/home.vimrc ~/.vimrc \
    &&  vim -not-a-term +PluginInstall +qall &>/dev/null \
    # End
    &&  true > /dev/null

RUN     set -x \
    # NodeJS
    &&  cp -fv ~/.config/repository/NodeJS/npm-global.sh /etc/profile.d/npm-global.sh \
    &&  cp -fv ~/.config/repository/NodeJS/npm-completion.sh /etc/bash_completion.d/npm-completion.sh \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Powershell
    &&  ln -sfv ~/.config/repository/PowerShell ~/.config/powershell \
    &&  ln -sfv ~/.config/repository/PowerShell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1 \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Python
    &&  cp -fv ~/.config/repository/Python/python-user-site.sh /etc/profile.d/python-user-site.sh \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Ruby
    #   Configuration
    &&  cp -fv ~/.config/repository/Ruby/ruby-gem-user-dir.sh /etc/profile.d/ruby-gem-user-dir.sh \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Tmux
    &&  ln -sfv ~/.config/repository/Tmux/tmux.conf ~/.tmux.conf \
    # End
    &&  true > /dev/null

RUN     set -x \
    # Nim
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            libssl-dev \
    &&  cp -fv ~/.config/repository/Nim/nimble.sh /etc/profile.d/nimble.sh \
    &&  bash -lc "nimble install -y nimlsp" \
    # Clean up
    &&  rm -rf ~/.cache \
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog
ENV TERM=xterm-color

CMD [ "bash", "-il" ]
