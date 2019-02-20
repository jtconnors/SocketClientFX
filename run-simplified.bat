
REM
REM Edit this variable
REM
SET REPO=C:\Users\jtconnor\.m2\repository\

SET TARGET=target\SocketClientFX-11.0.jar
set MAINCLASS=com.jtconnors.socketclientfx.SocketClientFX

SET MODPATH=%TARGET%;%REPO%com\jtconnors\com.jtconnors.socket\11.0.3\com.jtconnors.socket-11.0.3.jar;%REPO%org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1.jar;%REPO%org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1.jar;%REPO%org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1.jar;%REPO%org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1.jar;%REPO%org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1-win.jar;%REPO%org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1-win.jar;%REPO%org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1-win.jar;%REPO%org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1-win.jar

REM
REM Have to manually specify main class via jar --update until
REM maven-jar-plugin 3.1.2+ is released
ECHO
ECHO Did you run 'mvn jar:jar' first?
ECHO
jar --main-class %MAINCLASS% --update --file %TARGET%

java --module-path %MODPATH% -m socketclientfx
