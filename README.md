# SocketClientFX
JavaFX UI application representing the client side of a socket connection

This application is written in Java using the JavaFX API.  It represents the client side of a socket connection and can:

   - be configured to connect to either a localhost or remote socket at a configurable port
   - attempt to connect one time, or continually attempt to connect with a specified retry interval
   - send and receive text messages from a connected socket
   - retrieve sent and received messages

It is typically used in conjucntion with one of two server-side JavaFX UI applications:
```SocketServerFX``` (https://github.com/jtconnors/SocketServerFX)
                               - or -
```MultiSocketServerFX``` https://github.com/jtconnors/MultiSocketServerFX

This latest version of the source code is tagged ```1.0-JDK11-maven```.  It is modularized and as its name suggests, works with JDK11
and is built with the ```apache maven``` build lifecycle system.

Of note, the following maven goals can be executed:

   - ```mvn clean```
   - ```mvn dependency:copy-dependencies``` - to pull down dependent ```javafx``` and ```com.jtconnors.socket``` modules
   - ```mvn compile``` - to build the application
   - ```mvn package``` - to create the ```SocketClientFX``` module as a jar file
   - ```mvn exec:java``` to run the application
   
Furthermore, additional ```..sh and .bat``` files are provided in the ```sh/```
and ```bat/``` directories respectively:
   - ```sh/run.sh``` or ```bat\run.bat``` - script/bat file to run the application from the module path
   - ```sh/run-simplified.sh``` or ```bat\run-simplified.bat``` - alternative script/bat file to run the application, determines main class from ```SocketClientFX``` module
   - ```sh/link.sh``` or ```bat\link.bat``` - creates a runtime image using the ```jlink``` utility
   - ```sh/create-image.sh``` or ```bat\create-image.bat``` - creates a native package image of application using JEP-343 jpackage tool
   - ```sh/create-installer.sh``` or ```bat\create-iinstaller.bat``` - creates a native package installer of application using JEP-343 jpackage tool

Note:  these scripts will have to be slightly modified to account for where they are ultimately placed in your filesystem
   
See also:

- SocketServerFX: https://github.com/jtconnors/SocketServerFX
- MultiSocketServerFX: https://github.com/jtconnors/MultiSocketServerFX
- maven-com.jtconnors.socket: https://github.com/jtconnors/maven-com.jtconnors.socket
