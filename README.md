# SocketClientFX
JavaFX UI application representing the client side of a socket connection

This application is written in Java using the Java Module System and the JavaFX API.  It represents the client side of a socket connection and can:

   - be configured to connect to either a localhost or remote socket at a configurable port
   - attempt to connect one time, or continually attempt to connect with a specified retry interval
   - send and receive text messages from a connected socket
   - retrieve sent and received messages

It is typically used in conjucntion with one of two server-side JavaFX UI applications:
```SocketServerFX``` (https://github.com/jtconnors/SocketServerFX)
or
```MultiSocketServerFX``` https://github.com/jtconnors/MultiSocketServerFX

This version of the source code is tagged ```1.1-JDK17-maven```.  As its name suggests, it is specific to JDK 17 and can be built with the ```apache maven``` build lifecycle system. Scripts contained in this project will insist that JDK 17 be used, the first LTS release that formally includes the ```jpackage``` utility.  Subsequent JDK releases have not been tested with this version of the project. 

This project works on Windows, MacOS or Linux.

**Requirements:**
1. Your default JDK should point to a valid JDK 17 runtime in your ```PATH```.
2. Prior to running any of the scripts in this project, either the ```JAVA_HOME``` or ```$env:JAVA_HOME``` (depending upon the platform in question) environment variable must be set to a valid JDK 17 runtime.
3.  In order to generate ```EXE``` or ```MSI``` installers for Windows using the scripts in this project, the WiX toolkit version 3.0 or greater must be installed and placed on the ```PATH```.
4.  For certain Linux distributions (e.g. Oracle Linux ...) additional tooling, like for example  ```rpmbuild```, may be required in order to fully utilize the ```jpackage``` utility.

Of note, the following maven goals can be executed:

   - ```mvn clean```
   - ```mvn dependency:copy-dependencies``` - to pull down dependent ```javafx``` and ```com.jtconnors.socket``` modules
   - ```mvn compile``` - to build the application
   - ```mvn package``` - to create the ```SocketClientFX``` module as a jar file
   - ```mvn exec:java``` to run the application
   
Furthermore, additional ```.sh``` and ```.ps1``` files are provided in the ```sh/``` and ```ps1\``` directories respectively:
   - ```sh/run.sh``` or ```ps1\run.ps1``` - script file to run the application from the module path
   - ```sh/run-simplified.sh``` or ```ps1\run-simplified.ps1``` - alternative script file to run the application, determines main class from ```SocketClientFX``` module
   - ```sh/link.sh``` or ```ps1\link.ps1``` - creates a runtime image using the ```jlink``` utility
   - ```sh/create-appimage.sh``` or ```ps1\create-appimage.ps1``` - creates a native package image of application using JEP-343 jpackage tool
   - ```sh/create-deb-installer.sh``` - creates a native Linux DEB installer of this application using JEP-343 jpackage tool
   - ```sh/create-dmg-installer.sh``` - creates a native MacOS DMG installer of this application using JEP-343 jpackage tool
   - ```ps1\create-exe-installer.ps1``` - creates a native Windows EXE installer of this application using JEP-343 jpackage tool
   - ```ps1\create-msi-installer.ps1``` - creates a native Windows MSI installer of this application using JEP-343 jpackage tool
   - ```sh/create-pkg-installer.sh``` - creates a native MacOS PKG installer of this application using JEP-343 jpackage tool
   - ```sh/create-rpm-installer.sh``` - creates a native Linux RPM installer of this application using JEP-343 jpackage tool
   - ```ps1\create-generic-msi.ps1``` - creates a generic MSI installer of the JDK in use for this build, using the JEP-343 jpackage tool

Notes:
   - These scripts have a few available command-line options.  To print out
the options, add ```-?``` or ```--help``` as an argument to any script.
   - A sample ```Microsoft.PowerShell_profile.ps1``` file has been included to help configure a default Powershell execution environment.  A similar file can be generated specific to environments appropriate for running the ```bash(1)``` shell with a ```.bash_login``` or ```.bash_profile``` file.


See also:

- SocketServerFX: https://github.com/jtconnors/SocketServerFX
- MultiSocketServerFX: https://github.com/jtconnors/MultiSocketServerFX
- maven-com.jtconnors.socket: https://github.com/jtconnors/maven-com.jtconnors.socket
