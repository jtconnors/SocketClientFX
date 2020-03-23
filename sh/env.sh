
#
# Location of JDK with jpackage utility. This is here for legacy reasons.
# First prototype required a separate JDK build.  Starting with JDK 14,
# it's built into the standard JDK.
#
JPACKAGE_HOME=$JAVA_HOME

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
PROJECTDIR=..

#
# native platform
#
PLATFORM=mac

#
# Application specific variables
#
PROJECT=SocketClientFX
VERSION=14.0
MAINMODULE=socketclientfx
MAINCLASS=com.jtconnors.socketclientfx.SocketClientFX
MAINJAR=$PROJECT-$VERSION.jar
INSTALLERNAME=$PROJECT-$VERSION
LAUNCHER=$PROJECT

#
# Local maven repository for jars
#
REPO=~/.m2/repository

#
# Directory under which maven places compiled classes and built jars
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
    "$REPO/org/openjfx/javafx-base/14/javafx-base-14.jar"
    "$REPO/org/openjfx/javafx-controls/14/javafx-controls-14.jar"
    "$REPO/org/openjfx/javafx-fxml/14/javafx-fxml-14.jar"
    "$REPO/org/openjfx/javafx-graphics/14/javafx-graphics-14.jar"
    "$REPO/org/openjfx/javafx-base/14/javafx-base-14-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-controls/14/javafx-controls-14-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-fxml/14/javafx-fxml-14-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-graphics/14/javafx-graphics-14-$PLATFORM.jar"
)

#
# Create a module-path for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_MODULES defined in env.sh.
#
if [ -f $PROJECTDIR/$TARGET/$MAINJAR ]
then
	MODPATH=$TARGET/$MAINJAR
else
	MODPATH=$TARGET
fi
for ((i=0; i<${#EXTERNAL_MODULES[@]}; i++ ))
do
    MODPATH=${MODPATH}":""${EXTERNAL_MODULES[$i]}"
done

#
# Function to print command-line options to standard output
#
print_options() {
	echo usage: $0 [-?,--help,-e,-n,-v]
	echo -e "\t-? or --help - print options to standard output and exit"
	echo -e "\t-e - echo the jdk command invocations to standard output"
	echo -e "\t-n - don't run the java commands, just print out invocations"
	echo -e "\t-v - --verbose flag for jdk commands that will accept it"
	echo
}

#
# Process command-line arguments:  Not all flags are valid for all invocations,
# but we'll parse them anyway.
#
#   -? or --help  print options to standard output and exit
#   -e	echo the jdk command invocations to standard output
#   -n  don't run the java commands, just print out invocations
#   -v 	--verbose flag for jdk commands that will accept it
#
VERBOSE_OPTION=""
ECHO_CMD=false
EXECUTE_OPTION=true

for i in $*
do
	case $i in
		"-?")
			print_options
			exit 0
			;;
		"--help")
			print_options
			exit 0
			;;
		"-e")
			ECHO_CMD=true
			;;
		"-n")
			ECHO_CMD=true
			EXECUTE_OPTION=false
			;;
		"-v")
			VERBOSE_OPTION="--verbose"
			;;
                *)
			echo "$0: bad option '$i'"
			print_options
			exit 1
			;;
	esac
done

#
# Function to execute command specified by arguments.  If $ECHO_CMD is true
# then print the command out to standard output first.
#
exec_cmd() {
	if [ "$ECHO_CMD" = "true" ]
	then
		echo
		echo $*
	fi
        if [ "$EXECUTE_OPTION" = "true" ]
	then
		eval $*
	fi
}

#
# Check if $PROJECTDIR exists
#
if [ ! -d $PROJECTDIR ]
then
	echo Project Directory "$PROJECTDIR" does not exist. Edit PROJECTDIR variable in sh/env.sh
	exit 1
fi

#
# Check if $JPACKAGE_HOME exists
#
if [ ! -d $JPACKAGE_HOME ]
then
	echo jpackage home "$JPACKAGE_HOME" does not exist. Edit JPACKAGE_HOME variable in sh/env.sh
	exit 1
fi

cd $PROJECTDIR
