# Configuration for Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com/) which very quickly has become my favorite text-editor.

VsCode user-wide configuration lives in the `settings.json` in the following folder (depending on your OS):

| OS | Configuration Folder |
| - | - |
| **Windows** | `%APPDATA%\Code\User` |
| **Mac** | `~/Library/Application Support/Code/User` |
| **Linux** | `~/.config/Code/User` |

*Source: [Settings file locations](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations)*

## Point VsCode settings to this Git repository

I have found that the most reliable way to set up VsCode to use the settings and keybindings from your local clone of this repository is to replace the Configuration Folder with either a Junction link (on Windows) or a folder-symlink (on *NIX) to the Repository VsCode folder.

### Windows

``` cmd
REM Delete existing VsCode Configuration Folder
RD /S /Q "%APPDATA%\Code\User"
MD "%APPDATA%\Code" && MKLINK /J "%APPDATA%\Code\User" "%APPDATA%\Configuration Repository\VsCode"
```

### Linux

``` sh
rm -rfv ~/.config/Code/User
mkdir -p ~/.config/Code && ln -fsv ~/.config/repository/VsCode ~/.config/Code/User
```

### Future

In the future we might be able to use a similar trick as the `include.path` setting in a `.gitconfig` file.

ref.: [Add support for additional global config files (in addition to settings.json)](https://github.com/Microsoft/vscode/issues/17634)

## Additional folders in Configuration Folders

The [VsCode](../VsCode) folder contains a [`.gitignore`](./.gitignore) file containing rules to ignore the `snippets` and `workspaceStorage` folders that Visual Studio Code creates whenever you open a folder. *(Remember we have linked the local clone of this repository to the Configuration folder that is used by VsCode.)*

## VS Code Extensions

`extensions.txt` list all extensions used for VS Code.

### Export Command

Use the following commands to export the extensions used in VS Code.

#### Windows export

``` bat
code --list-extensions > "%APPDATA%\Configuration Repository\VsCode\extensions.txt"
```

#### Linux export

``` sh
code --list-extensions > ~/.config/repository/VsCode/extensions.txt
```

### Import Command

Execute the following command to install all listed extensions

#### Windows import

``` txt
PUSHD "%APPDATA%\Configuration Repository\VsCode"
FOR /F %E IN (extensions.txt) DO @code --install-extension "%~E"
POPD
```

#### Linux import

``` sh
while read e; do
  code --install-extension "$e"
done < ~/.config/repository/VsCode/extensions.txt
```
