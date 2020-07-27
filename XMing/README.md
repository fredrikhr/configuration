# GUI in WSL

If running a WSL shell in Windows, XMing can be installed on Windows. Since XMing is a X-Server compliant server, WSL can then be set up to redirect GUIs inside the WSL session to the XMing-server on the host.

## Autostart XMing

To setup autostart of XMing run the following commands, to start Xming on login:

``` bat
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v XMing /t REG_SZ /d """C:\Program Files (x86)\Xming\Xming.exe" :0 -clipboard -multiwindow""
```

Or for non-admin users:

``` bat
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v XMing /t REG_SZ /d """C:\Program Files (x86)\Xming\Xming.exe" :0 -clipboard -multiwindow""
```

## Inside WSL

``` sh
sudo cp -fv ~/.config/repository/XMing/xming-display-export.sh /etc/profile.d/xming-display-export.sh
```
