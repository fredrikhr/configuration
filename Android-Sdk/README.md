# Android SDK

On Windows, the Android SDK is usually installed in either of these locations:

* `%LOCALAPPDATA%\Android\Sdk` (User-local install)
* `C:\Program Files\Android\Sdk` (System-wide install)

The Android SDK command-line tools include one folder `tools` that is extracted into one of the locations mentioned above.

## `JAVA_HOME` issues

On Windows, if the Java SDK is installed, the java executable recognized by the Android SDK is the JRE bundled with the JDK. The version might be different to the current version of the JRE and cause problems.

For that reason, it is useful to add a script that unsets the `JAVA_HOME` environment variable that is used by the JDK, so that the Android SDK tools will use the `java.exe` on the current `PATH`.

Create the folder `cmd` inside the `tools` folder of the SDK (`cmd` can be replaced by another name, but it must be a sibling to the `bin` folder). Execute the following command from the `tools` directory of the Android SDK.

``` cmd
FOR %B in (.\bin\*.bat) DO COPY /Y "%APPDATA%\Configuration Repository\Android-Sdk\wrap-tool-without-java-home.cmd" ".\cmd\%~nB.cmd"
CALL .\cmd\sdkmanager.cmd --version
```
