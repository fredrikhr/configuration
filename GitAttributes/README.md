# `.gitattributes` files

The `.gitattributes` file is a dotfile that instructs Git on how to handle file checkouts, commits and changes for files in your repository.

The file was originally created by Visual Studio 2017, and I have subsequently added by own attributes at the end.

Node.js, NPM and Yarn all *really* want to use UNIX-like line endings (LF) even when on Windows. This causes false positives on changes to these files.

Therefore I enforce LF line-endings by Git for the affected files. On Linux, these settings have no effect.
