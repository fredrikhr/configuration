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
    # Bash-completions
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            bash-completion \
    #
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # GCC / G++
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            build-essential \
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
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Microsoft Packages APT Feed
    &&  wget "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb 2>&1 \
    &&  dpkg -i /tmp/packages-microsoft-prod.deb \
    &&  rm -f /tmp/packages-microsoft-prod.deb \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # .NET Core
    &&  apt-get update \
    &&  apt-get install --yes \
            dotnet-sdk-3.1 \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Powershell
    &&  apt-get update \
    &&  apt-get install --yes \
            powershell \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Python
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            python \
            python-pip \
            python3 \
            python3-pip \
            python3-venv \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Ruby
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            ruby \
            ruby-dev \
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
    # Clean up
    &&  rm -rf /opt/nim-$NIM_VERSION/c_code \
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*

RUN     set -x \
    # Java Runtime Environment
    #   Installation
    #
    &&  apt-get update \
    &&  apt-get install --yes --no-install-recommends \
            default-jre \
    # Clean up
    &&  apt-get autoremove -y \
    &&  apt-get clean -y \
    &&  rm -rf /var/lib/apt/lists/*


ENV DEBIAN_FRONTEND=dialog
