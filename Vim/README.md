# Vim setup

## Windows

``` bat
MD "%USERPROFILE%\.vim"
MKLINK /J "%USERPROFILE%\.vim\config" "%APPDATA%\Configuration Repository\Vim"
git clone https://github.com/VundleVim/Vundle.vim.git -- "%USERPROFILE%\.vim\bundle\Vundle.vim"
COPY "%USERPROFILE%\.vim\config\home.vimrc" "%USERPROFILE%\.vimrc"
```

## Linux

``` sh
mkdir -p ~/.vim
git clone https://github.com/VundleVim/Vundle.vim.git -- ~/.vim/bundle/Vundle.vim
ln -sfv ~/.config/repository/Vim ~/.vim/config
ln -sfv ~/.vim/config/home.vimrc ~/.vimrc
```
