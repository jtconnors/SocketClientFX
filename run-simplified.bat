
REM
REM Edit this variable
REM
SET REPO=C:\Users\jtconnor\.m2\repository\

SET TARGET=target\SocketClientFX-11.0.jar
set MAINCLASS=com.jtconnors.socketclientfx.SocketClientFX

SET MODPATH=%TARGET%;%REPO%com\jtconnors\com.jtconnors.socket\11.0.3\com.jtconnors.socket-11.0.3.jar;%REPO%org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1.jar;%REPO%org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1.jar;%REPO%org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1.jar;%REPO%org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1.jar;%REPO%org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1-win.jar;%REPO%org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1-win.jar;%REPO%org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1-win.jar;%REPO%org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1-win.jar

REM
REM may need to run 'mvn jar:jar' first to create the %TARGET%
REM

jar --main-class %MAINCLASS% --update --file %TARGET%

java --module-path %MODPATH% -m socketclientfx