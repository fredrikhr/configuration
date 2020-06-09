if [ -f ~/.choosenim/current ]; then
    export PATH="$(cat ~/.choosenim/current)/bin:$PATH"
fi
