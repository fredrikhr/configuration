FROM fredrikhr/devcontainer:base-ubuntu-18.04

RUN     set -x \
    # Configuration Repository
    &&  mkdir -p /etc/skel/.config \
    &&  cp -rf ~/.config/repository /etc/skel/.config/repository

RUN     set -x \
    # Git
    &&  mkdir -p /etc/skel/.local/share/git-credential-manager/ \
    &&  cp -f \
            ~/.local/share/git-credential-manager/git-credential-manager-2.0.4.jar \
            /etc/skel/.local/share/git-credential-manager/

RUN     set -x \
    # Vim
    &&  mkdir -p /etc/skel/.vim \
    &&  cp -fr ~/.vim/bundle /etc/skel/.vim/bundle

ENV TERM=xterm-color

CMD [ "bash", "-il" ]
