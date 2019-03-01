
#
# Location of JDK with jpackage utility.  We defult to the user's Download
# directory.  If it's in a different place, this variable must be changed.
#
Set-Variable -Name JPACKAGE_HOME -Value ~\Downloads\jdk-13

#
# Unless these script files have been deliberately moved, the parent
# directory of the directory containining these script files houses
# the maven project and source code.
#
PROJECTDIR=..

#
# native platform
#
Set-Variable -Name PLATFORM -Value win
Set-Variable -Name INSTALLER_TYPE -Value exe

#
# Application specific variables
#
Set-Variable -Name PROJECT -Value SocketClientFX
Set-Variable -Name MAINMODULE -Value socketclientfx
Set-Variable -Name MAINCLASS -Value com.jtconnors.socketclientfx.SocketClientFX
Set-Variable -Name MAINJAR -Value SocketClientFX-11.0.jar
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
#
Set-Variable -Name EXTERNAL_MODULES -Value @(
    "$REPO\com\jtconnors\com.jtconnors.socket\11.0.3\com.jtconnors.socket-11.0.3.jar",
    "$REPO\org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1.jar",
    "$REPO\org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1.jar",
    "$REPO\org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1.jar",
    "$REPO\org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1.jar",
    "$REPO\org\openjfx\javafx-base\11.0.1\javafx-base-11.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-controls\11.0.1\javafx-controls-11.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-fxml\11.0.1\javafx-fxml-11.0.1-$PLATFORM.jar",
    "$REPO\org\openjfx\javafx-graphics\11.0.1\javafx-graphics-11.0.1-$PLATFORM.jar"
)

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
# Check if $JPACKAGE_HOME exists
#
if (-not (Test-Path $JPACKAGE_HOME)) {
	GoodBye "jpackage home '$JPACKAGE_HOME' does not exist. Edit JPACKAGE_HOME viariable in ps1\env.ps1." $LASTEXITCODE 
}

cd $PROJECTDIR
