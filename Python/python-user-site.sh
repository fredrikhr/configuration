python_command=
if which python3 >/dev/null; then
    python_command=python3
elif which python2 >/dev/null; then
    python_command=python2
elif which python >/dev/null; then
    python_command=python
fi
if [ -n "$python_command" ]
then
    export PATH="$($python_command -m site --user-base)/bin:$PATH"
fi
