if [[ $(find "~/.config/repository/Config-Repository-Update/.touch" -mtime +7 -print) ]]; then
    # nothing happens
else
    pushd ~/.config/repository

    {
        if [ -z "$(git status --porcelain)" ]; then
            # Working directory clean
            echo "--------------------"
            echo "Pulling ~/.config/repository"
            git pull
            echo "--------------------"
            echo "--------------------"
        else
            # Uncommitted changes
            echo "Could not pull ~/.config/repository"
            git status
        fi
    } || {
        # Do nothing
    }

    popd

    touch "~/.config/repository/Config-Repository-Update/.touch"
fi
