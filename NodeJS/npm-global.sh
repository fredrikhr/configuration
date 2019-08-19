if which node >/dev/null && which npm >/dev/null; then
    npm config set prefix '~/.npm-global'
    export PATH="$HOME/.npm-global/bin:$PATH"
fi
