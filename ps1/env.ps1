
#
# These variables must refer to the project name and the directory
# in the filesystem where the project resides respectively
#
Set-Variable -Name PROJECT -Value SocketClientFX
Set-Variable -Name PROJECTDIR -Value $HOME\Documents\NetBeansProjects\$PROJECT

#
# Location of JDK with jpackage utility
#
Set-Variable -Name JPACKAGE_HOME -Value \Users\jtconnor\Downloads\jdk-13

#
# native platform
#
Set-Variable -Name PLATFORM -Value win
Set-Variable -Name INSTALLER_TYPE -Value exe

#
# Application specific variables
#
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

#
# Process command-line arguments:  Not all flags are vaild for all invocations, but we'll parse them
# anyway.
#
#   -e	echo the jdk command invocations to standard output
#   -n  don't run the java commands, just print out invocations
#   -v 	--verbose flag for jdk commands that will accept it
#   -exe generate an EXE installer type for Windows
#   -msi generate an MSI installer type for Windows
#
Set-Variable -Name VERBOSE_OPTION -Value $null
Set-Variable -Name ECHO_CMD -Value false
Set-Variable -Name EXECUTE_OPTION -Value true

    Foreach ($arg in $CMDLINE_ARGS) {
        switch ($arg) {
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
            '-exe' {
                Set-Variable -Name INSTALLER_TYPE -Value exe
            }
            '-msi' {
                Set-Variable -Name INSTALLER_TYPE -Value msi
            }
        }
    }

#
# Print a command with all its args on one line. 
#
function Print-Cmd {
    Foreach ($item in $args[0]) {
       $CMD += $item
       $CMD += " "
    }
    Write-Output $CMD
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
        if ($LASTEXITCODE -ne 0) {
            Exit $LASTEXITCODE
        }
    }
}

#
# Check if $PROJECTDIR exists
#
if (-not (Test-Path $PROJECTDIR)) {
    Set-Variable -Name SAVED_LASTEXITCODE -Value $LASTEXITCODE
	Write-Output "Project Directory '$PROJECTDIR' does not exist"
    if ($ORIGINALDIR -ne $null) {
        cd $ORIGINALDIR
    }
	Exit $SAVED_LASTEXITCODE
}

#
# Check if $JPACKAGE_HOME exists
#
if (-not (Test-Path $JPACKAGE_HOME)) {
    Set-Variable -Name SAVED_LASTEXITCODE -Value $LASTEXITCODE
	Write-Output "jpackage home '$JPACKAGE_HOME' does not exist"
    if ($ORIGINALDIR -ne $null) {
        cd $ORIGINALDIR
    }
    Exit $SAVED_LASTEXITCODE
}

cd $PROJECTDIR
