
#
# Edit these variables
#
REPO=/Users/jtconnor/.m2/repository
PLATFORM=mac

TARGET=target/classes
MAINMODULE=socketclientfx
MAINCLASS=com.jtconnors.socketclientfx.SocketClientFX
LAUNCHER=SocketClientFX

MODULES=(
    "$TARGET"
    "$REPO/com/jtconnors/com.jtconnors.socket/11.0.3/com.jtconnors.socket-11.0.3.jar"
    "$REPO/org/openjfx/javafx-base/11.0.1/javafx-base-11.0.1.jar"
    "$REPO/org/openjfx/javafx-controls/11.0.1/javafx-controls-11.0.1.jar"
    "$REPO/org/openjfx/javafx-fxml/11.0.1/javafx-fxml-11.0.1.jar"
    "$REPO/org/openjfx/javafx-graphics/11.0.1/javafx-graphics-11.0.1.jar"
    "$REPO/org/openjfx/javafx-base/11.0.1/javafx-base-11.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-controls/11.0.1/javafx-controls-11.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-fxml/11.0.1/javafx-fxml-11.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-graphics/11.0.1/javafx-graphics-11.0.1-$PLATFORM.jar"
)

# Create a module-path for the java command from the modules listed above
MODPATH="${MODULES[0]}"
for ((i=1; i<${#MODULES[@]}; i++ ))
do
    MODPATH=${MODPATH}":""${MODULES[$i]}"
done

CMD="jlink --module-path $MODPATH --add-modules $MAINMODULE --compress=2 --launcher $LAUNCHER=$MAINMODULE/$MAINCLASS --output image"
echo $CMD
eval $CMD
