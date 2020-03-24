
####################
#
# All Scripts should have this preamble     
#
Set-variable -Name CMDLINE_ARGS -Value $args

#
# Move to the directory containing this script so we can source the env.ps1
# properties that follow
#
$STARTDIR = pwd | Select-Object | %{$_.ProviderPath}
cd $PSScriptRoot

#
# Common properties shared by scripts
#
. .\env.ps1
if ($Global:JUST_EXIT -eq "true") {
    cd $STARTDIR
    Exit 1
}
#
# End preamble
#
####################

#
# Create a module-path for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_MODULES defined in env.ps1.
#
#if (Test-Path $TARGET\$MAINJAR) {
#    Set-Variable -Name MODPATH -Value $TARGET\$MAINJAR
#} else {
#     Set-Variable -Name MODPATH -Value $TARGET
#}
#ForEach ($i in $EXTERNAL_MODULES) {
#   $MODPATH += ";"
#   $MODPATH += $i
#}

#
# Run the Java command
#
Set-Variable -Name JAVA_ARGS -Value @(
    '--module-path',
    """$MODPATH""",
    "-m",
    """$MAINMODULE/$MAINCLASS"""
)
#Exec-Cmd("java.exe", $JAVA_ARGS)
Exec-Cmd("$env:JAVA_HOME\bin\java.exe", $JAVA_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
