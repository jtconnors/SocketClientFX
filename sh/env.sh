
# 
# JAVA_HOME environment variable must be set either externally in your
# environment or internally here by uncommenting out one of the lines
# below and assiging it the location of a valid JDK 17 runtime.
#
# MacOS example
#export JAVA_HOME="~/IDE/jdk-17.jdk/Contents/Home"
# Linux Example
#export JAVA_HOME="~/jdk-17"

#
# Until the jpackage module API is formalized, each JDK release (starting with
# JDK 14), will go through refinements meaning there may be incompatibilities.
# Until the API is cast in stone, we'll check to make sure the JDK version
# in use matches the EXPECTED_JDK_VERSION defined below
#
EXPECTED_JDK_VERSION="17"

#
# Location of JDK with jpackage utility. This is here for legacy reasons.
# First prototype required a separate JDK build.  Starting with JDK 14,
# it's built into the standard JDK.
#
JPACKAGE_HOME=$JAVA_HOME

#
# Vendor string used when creating native installers with the
# jpackage utility.
#
VENDOR_STRING="jtconnors.com"

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
PROJECTDIR=..

#
# Determine Operating System platform. Currently only MacOS (PLATFORM=mac)
# and Linux (PLATFORM=linux) are supported.
#
case "$(uname)" in
	Darwin)
		PLATFORM=mac
		;;
	Linux)
		PLATFORM=linux
		;;
	*)
		echo "Only x86_64 versions of MacOS or Linux supported, '$(uname)' unavailable."
	exit 1
esac

#
# Application specific variables
#
PROJECT=SocketClientFX
VERSION=17.0
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
# For JDK 17 javafx modules, make sure to use version 17.0.0.1 or greater
#
EXTERNAL_MODULES=(
    "$REPO/com/jtconnors/com.jtconnors.socket/11.0.3/com.jtconnors.socket-11.0.3.jar"
    "$REPO/org/openjfx/javafx-base/17.0.0.1/javafx-base-17.0.0.1.jar"
    "$REPO/org/openjfx/javafx-controls/17.0.0.1/javafx-controls-17.0.0.1.jar"
    "$REPO/org/openjfx/javafx-fxml/17.0.0.1/javafx-fxml-17.0.0.1.jar"
    "$REPO/org/openjfx/javafx-graphics/17.0.0.1/javafx-graphics-17.0.0.1.jar"
    "$REPO/org/openjfx/javafx-base/17.0.0.1/javafx-base-17.0.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-controls/17.0.0.1/javafx-controls-17.0.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-fxml/17.0.0.1/javafx-fxml-17.0.0.1-$PLATFORM.jar"
    "$REPO/org/openjfx/javafx-graphics/17.0.0.1/javafx-graphics-17.0.0.1-$PLATFORM.jar"
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
# Check if JAVA_HOME is both set and assigned to a valid Path
#
if [ -z $JAVA_HOME ]
then
    echo "JAVA_HOME Environment Variable is not set. Set the JAVA_HOME variable to a vaild JDK runtime location in your environment or uncomment and edit the 'export JAVA_HOME=' statement at the beginning of the sh/env.sh file." 
	exit 1
elif [ ! -d $JAVA_HOME ]
then
    echo "Path for JAVA_HOME \"$JAVA_HOME\" does not exist. Set the JAVA_HOME variable to a vaild JDK runtime location in your environment or uncomment and edit the 'export JAVA_HOME=' statement at the beginning of the sh\env.sh file."
	exit 1
fi

#
# Check to make sure we have the proper Java Version
#
java_version_output=`$JAVA_HOME/bin/java -version 2>&1`
jdk_version_unfiltered=`echo $java_version_output | awk -F" " '{print $3}'`
# Some versions return the Java version in double quotes ("").  Git rid of
# them for a proper comparison.
jdk_version_untruncated=`echo $jdk_version_unfiltered | sed 's/"//g'`
# Truncate anything after major release i.e. 14.0.2 => 14, 11-redhat.0.1 => 11
jdk_version=`echo $jdk_version_untruncated | cut -d"." -f1 | cut -d"-" -f1`
if [ "$jdk_version" != "$EXPECTED_JDK_VERSION" ]
then
    echo "JDK version '$jdk_version' does not match expected version: '$EXPECTED_JDK_VERSION'. JAVA_HOME should be set to a JDK $EXPECTED_JDK_VERSION implementation."
	exit 1
fi


#
# Check if $JPACKAGE_HOME exists
#
if [ ! -d $JPACKAGE_HOME ]
then
	echo "jpackage home \"$JPACKAGE_HOME\" does not exist. Edit JPACKAGE_HOME variable in sh/env.sh"
	exit 1
fi

cd $PROJECTDIR
