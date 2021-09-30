
#
# JAVA_HOME environment variable must be set either externally in the Poweshell
# environment or internally here by uncommenting out the Set-Variable line
# below and assiging it the location of a valid JDK 17 runtime.
#
#$env:JAVA_HOME = 'D:\openjdk\jdk-17'

#
# Until the jpackage module API is formalized, each JDK release (starting with
# JDK 14), will go through refinements meaning there may be incompatibilities.
# Until the API is cast in stone, we'll check to make sure the JDK version
# in use matches the EXPECTED_JDK_VERSION defined below
#
Set-Variable -Name EXPECTED_JDK_VERSION -Value "17"


#
# Location of JDK with jpackage utility. This is here for legacy reasons.
# First prototype required a separate JDK build.  Starting with JDK 14,
# it's built into the standard JDK.
#
Set-Variable -Name JPACKAGE_HOME -Value $env:JAVA_HOME

#
# Vendor string used when creating native installers with the
# jpackage utility.
#
Set-Variable -Name VENDOR_STRING -Value "jtconnors.com"

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
Set-Variable -Name PROJECTDIR -Value ".."

#
# native platform
#
Set-Variable -Name PLATFORM -Value win

#
# Application specific variables
#
Set-Variable -Name PROJECT -Value SocketClientFX
Set-Variable -Name VERSION -Value "17.0"
Set-Variable -Name MAINMODULE -Value socketclientfx
Set-Variable -Name MAINCLASS -Value com.jtconnors.socketclientfx.SocketClientFX
Set-Variable -Name MAINJAR -Value $PROJECT-$VERSION.jar
Set-Variable -Name INSTALLERNAME -Value $PROJECT-$VERSION
Set-Variable -Name LAUNCHER -Value $PROJECT

#
# Local maven repository for jars
#
Set-Variable -Name REPO -Value $HOME\.m2\repository

#
# Directory under which maven places compiled classes and built jars
#
Set-Variable -Name TARGET -Value target

#
# Directory where custom runtime image (via jlink) is created
#
Set-Variable -Name IMAGE -Value image

#
# Directory where application image (via jpackage) is created
#
Set-Variable -Name APPIMAGE -Value appimage

#
# Directory where application installer (via jpackage) is created
#
Set-Variable -Name INSTALLER -Value installer

#
# Required external modules for this application
# For JDK 17 javafx modules, make sure to use version 17.0.0.1 or greater
#
Set-Variable -Name EXTERNAL_MODULES -Value @(
    "$REPO\com\jtconnors\com.jtconnors.socket\11.0.3\com.jtconnors.socket-11.0.3.jar",
    "$REPO\org\openjfx\javafx-base\17.0.0.1\javafx-base-17.0.0.1.jar",
    "$REPO\org\openjfx\javafx-controls\17.0.0.1\javafx-controls-17.0.0.1.jar",
    "$REPO\org\openjfx\javafx-fxml\17.0.0.1\javafx-fxml-17.0.0.1.jar",
    "$REPO\org\openjfx\javafx-graphics\17.0.0.1\javafx-graphics-17.0.0.1.jar",
    "$REPO\org\openjfx\javafx-base\17.0.0.1\javafx-base-17.0.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-controls\17.0.0.1\javafx-controls-17.0.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-fxml\17.0.0.1\javafx-fxml-17.0.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-graphics\17.0.0.1\javafx-graphics-17.0.0.1-$PLATFORM.jar"
)

#
# Create a module-path for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_MODULES defined in env.ps1.
#
if (Test-Path $PROJECTDIR\$TARGET\$MAINJAR) {
    Set-Variable -Name MODPATH -Value $TARGET\$MAINJAR
} else {
     Set-Variable -Name MODPATH -Value $TARGET
}
ForEach ($i in $EXTERNAL_MODULES) {
   $MODPATH += ";"
   $MODPATH += $i
}

Set-Variable -Name SCRIPT_NAME -Value $MyInvocation.MyCommand.Name

#
# Function to print command-line options to standard output
#
function Print-Options {
    Write-Output "usage: ${SCRIPT_NAME} [-?,--help,-e,-n,-v]"
    Write-Output "  -? or --help - print options to standard output and exit"
    Write-Output "  -e - echo the jdk command invocations to standard output"
    Write-Output "  -n - don't run the java commands, just print out invocations"
    Write-Output "  -v - --verbose flag for jdk commands that will accept it"
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
Set-Variable -Name VERBOSE_OPTION -Value $null
Set-Variable -Name ECHO_CMD -Value false
Set-Variable -Name EXECUTE_OPTION -Value true
Set-Variable -Name JUST_EXIT -Value false -Scope Global


Foreach ($arg in $CMDLINE_ARGS) {
    switch ($arg) {
        '-?' {
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global 
        }
        '--help' {
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global
        }
        '-e' { 
            Set-Variable -Name ECHO_CMD -Value true   
        }
        '-n' { 
            Set-Variable -Name ECHO_CMD -Value true
            Set-Variable -Name EXECUTE_OPTION -Value false   
        }
        '-v' {
            Set-Variable -Name VERBOSE_OPTION -Value "--verbose"
        }
        default {
            Write-Output "${SCRIPT_NAME}: bad option '$arg'"
            Print-Options
            Set-Variable -Name JUST_EXIT -Value true -Scope Global
        }
    }
}

#
# Print a command with all its args on one line. 
#
function Print-Cmd {
    Write-Output ""
    Foreach ($item in $args[0]) {
       $CMD += $item
       $CMD += " "
    }
    Write-Output $CMD
}

#
# Function to print out an error message and exit with exitcode
#
function GoodBye($MSG, $EXITCODE) {
   Write-Output $MSG
   Set-Variable -Name JUST_EXIT -Value true -Scope Global
   Exit $EXITCODE    
}

#
# Function to execute command specified by arguments.
# If $ECHO_CMD is true then print the command out to standard output first.
# If $EXECUTE_OPTION is set to anything other than "true", then don't execute
# command, just print it out.
#
function Exec-Cmd {
    Set-Variable -Name OPTIONS -Value @()
    $COMMAND = $($args[0][0])
    Foreach ($item in $args[0][1]) {
       $OPTIONS += $item
    }
    if ($ECHO_CMD -eq "true") {
        Print-Cmd ($COMMAND, $OPTIONS)
    }
    if ($EXECUTE_OPTION -eq "true") {
        & $COMMAND $OPTIONS
    }
}

#
# Check if $PROJECTDIR exists
#
if (-not (Test-Path $PROJECTDIR)) {
	GoodBye " Project Directory '$PROJECTDIR' does not exist. Edit PROJECTDIR variable in ps1\env.ps1." $LASTEXITCODE
}

#
# Check if $env:JAVA_HOME is both set and assigned to a valid Path
#
if ($env:JAVA_HOME -eq $null) {
    GoodBye "env:JAVA_HOME Environment Variable is not set. Set the env:JAVA_HOME variable to a vaild JDK runtime location in your Powershell environment or uncomment and edit the 'set-Variable' statement at the beginning of the ps1\env.ps1 file." $LASTEXITCODE 
} elseif (-not (Test-Path $env:JAVA_HOME)) {
	GoodBye "Path for Java Home 'env:JAVA_HOME' does not exist. Set the env:JAVA_HOME variable to a vaild JDK runtime location in your Powershell environment or uncomment and edit the 'set-Variable' statement at the beginning of the ps1\env.ps1 file." $LASTEXITCODE 
}

#
# Check if $JPACKAGE_HOME exists
#
if (-not (Test-Path $JPACKAGE_HOME)) {
	GoodBye "jpackage home '$JPACKAGE_HOME' does not exist. Edit JPACKAGE_HOME viariable in ps1\env.ps1." $LASTEXITCODE 
}

#
# Check to make sure we have the proper Java Version
#
$java_version_output = cmd /c "$env:JAVA_HOME\bin\java.exe -version 2>&1"
$jdk_version_unfiltered = $java_version_output.Split(" ")[2].split(".-")[0]
# Some versions return the Java version in double quotes ("").  Git rid of
# them for a proper comparison.
$jdk_version = $jdk_version_unfiltered -replace '["]'
if ($jdk_version -ne $EXPECTED_JDK_VERSION) {
    GoodBye "JDK version '$jdk_version' does not match expected version: '$EXPECTED_JDK_VERSION'. JAVA_HOME should be set to a JDK $EXPECTED_JDK_VERSION implementation." $LASTEXITCODE
}

cd $PROJECTDIR
