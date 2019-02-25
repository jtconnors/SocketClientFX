
#
# These variables must refer to the project name and the directory
# in the filesystem where the project resides respectively
#
PROJECT=SocketClientFX
PROJECTDIR=~/NetBeansProjects/$PROJECT

if [ ! -d $PROJECTDIR ]
then
	echo Project Directory "$PROJECTDIR" does not exist
	exit 1
fi

cd $PROJECTDIR

#
# Location of JDK with jpackage utility
#
JPACKAGE_HOME=~/Downloads/jdk-13.jdk/Contents/Home

if [ ! -d $JPACKEAGE_HOME ]
then
	echo jpackage home "$JPACKEAGE_HOME" does not exist
	exit 1
fi

#
# Application specific variables
#
MAINMODULE=socketclientfx
MAINCLASS=com.jtconnors.socketclientfx.SocketClientFX
MAINJAR=SocketClientFX-11.0.jar
LAUNCHER=$PROJECT

#
# Local maven repository for jars
#
REPO=~/.m2/repository

#
# native platform
#
PLATFORM=mac
INSTALLER_TYPE=dmg

#
# Directory under which  maven places compiled classes and build jars
#
TARGET=target

#
# Directory where custom runtime image (via jlink) is created
#
IMAGE=image

#
# Directory where application image (via jpackage) is created
#
APPIMAGE=appimage

#
# Directory where application installer (via jpackage) is created
#
INSTALLER=installer

#
# Required external modules for this application
#
EXTERNAL_MODULES=(
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

#
# Process command-line arguments:
#
#   -v 	--verbose flag for jdk commands that will accept it
#   -e	echo the jdk command invocations to standard output
#
VERBOSE_OPTION=""
ECHO_CMD=false

for i in $*
do
	if [ "$i" = "-v" ]
	then
		VERBOSE_OPTION="--verbose"
	elif [ "$i" = "-e" ]
	then
		ECHO_CMD=true
	fi
done

#
# Function to execute command specified by arguments.  If $ECHO_CMD is true
# then print the commant out to standard ouitput first.
#
exec_cmd() {
	if [ "$ECHO_CMD" = "true" ]
	then
		echo $*
	fi
	eval $*
}
