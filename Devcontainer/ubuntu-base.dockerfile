FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN     set -x \
    # APT Update & Upgrade
    &&  apt-get update \
    &&  apt-get upgrade --yes \
    &&  apt-get install --yes --no-install-recommends \
            apt-transport-https \
            wget \
            xz-utils \
    #
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Configuration Repository (Current User)
    &&  git clone --depth 1 https://github.com/fredrikhr/configuration.git -- ~/.config/repository 2>&1

RUN     set -x \
    # Config: Bash
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            bash-completion \
    &&  cp -fv ~/.config/repository/Bash/prompt-new-line.bash /etc/bash_completion.d/prompt-new-line.bash \
    &&  ln -sfv ~/.config/repository/Bash/bash-aliases.bash ~/.bash_aliases \
    &&  mkdir -p ~/.bashrc.d \
    &&  ln -sfv ~/.config/repository/Bash/bash-completion.sh ~/.bashrc.d/bash-completion.sh \
    #
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Git
    &&  ln -sfv ~/.config/repository/Git/Home.unix.gitconfig ~/.gitconfig \
    &&  cp -v ~/.config/repository/Git/git-user.sample.gitconfig ~/.config/repository/Git/git-user.gitconfig \
    &&  mkdir -p ~/.local/share/git-credential-manager/ \
    &&  wget -O ~/.local/share/git-credential-manager/git-credential-manager-2.0.4.jar \
            https://github.com/microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.4/git-credential-manager-2.0.4.jar 2>&1 \
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            default-jre \
    #
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Vim
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            vim-nox \
            vim-editorconfig \
            vim-syntastic \
    &&  git clone https://github.com/VundleVim/Vundle.vim.git -- ~/.vim/bundle/Vundle.vim  2>&1 \
    &&  ln -sfv ~/.config/repository/Vim ~/.vim/config \
    &&  ln -sfv ~/.vim/config/home.vimrc ~/.vimrc \
    &&  vim -not-a-term +PluginInstall +qall \
    &&  update-alternatives --set editor /usr/bin/vim.nox  2>&1 \
    #
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # NodeJS
    #   Installation
    #
    &&  curl -sL https://deb.nodesource.com/setup_12.x | bash - 2>&1 \
    &&  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 2>/dev/null \
    &&  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    &&  apt-get update \
    &&  apt-get install --yes nodejs yarn \
    #   Configuration
    #
    &&  cp -fv ~/.config/repository/NodeJS/npm-global.sh /etc/profile.d/npm-global.sh \
    &&  cp -fv ~/.config/repository/NodeJS/npm-completion.sh /etc/bash_completion.d/npm-completion.sh \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # .NET Core & Powershell
    #   Installation
    #
    &&  wget "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb 2>&1 \
    &&  dpkg -i /tmp/packages-microsoft-prod.deb \
    &&  rm -f /tmp/packages-microsoft-prod.deb \
    &&  apt-get update \
    &&  apt-get install --yes \
            dotnet-sdk-3.1 \
            powershell \
    #   Configuration
    &&  ln -sfv ~/.config/repository/PowerShell ~/.config/powershell \
    &&  ln -sfv ~/.config/repository/PowerShell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1 \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Python
    #   Installation
    #
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            python \
            python-pip \
            python3 \
            python3-pip \
            python3-venv \
    #   Configuration
    &&  cp -fv ~/.config/repository/Python/python-user-site.sh /etc/profile.d/python-user-site.sh \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Ruby
    #   Installation
    #
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            ruby \
            ruby-dev \
    #   Configuration
    &&  cp -fv ~/.config/repository/Ruby/ruby-gem-user-dir.sh /etc/profile.d/ruby-gem-user-dir.sh \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Tmux
    #   Installation
    #
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            tmux \
    #   Configuration
    &&  ln -sfv ~/.config/repository/Tmux/tmux.conf ~/.tmux.conf \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Nim
    #   Installation
    &&  export NIM_VERSION="$(curl -sL https://nim-lang.org/channels/stable)" \
    &&  curl -sL "https://nim-lang.org/download/nim-$NIM_VERSION-linux_x64.tar.xz" \
     |  tar -C /opt -xJ \
    &&  echo "export PATH=\$PATH:/opt/nim-$NIM_VERSION/bin" | tee /etc/profile.d/nimpath.sh \
    &&  export PATH=$PATH:/opt/nim-$NIM_VERSION/bin \
    #   Configuration
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            build-essential \
            libssl-dev \
    &&  cp -fv ~/.config/repository/Nim/nimble.sh /etc/profile.d/nimble.sh \
    &&  bash -lc "nimble install -y nimlsp" \
    # Clean up
    &&  rm -rf /opt/nim-$NIM_VERSION/c_code ~/.cache \
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog
ENV TERM=xterm-color

CMD [ "bash", "-il" ]
