MD "%USERPROFILE%\.vim"
MKLINK /J "%USERPROFILE%\.vim\config" "%APPDATA%\Configuration Repository\Vim"
IF NOT EXIST "%USERPROFILE%\.vim\bundle\Vundle.vim" git clone https://github.com/VundleVim/Vundle.vim.git -- "%USERPROFILE%\.vim\bundle\Vundle.vim"
COPY "%USERPROFILE%\.vim\config\home.vimrc" "%USERPROFILE%\.vimrc"