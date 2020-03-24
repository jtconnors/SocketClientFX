
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
# Run the Java command
#
Set-Variable -Name JAVA_ARGS -Value @(
    "--module-path",
    """$MODPATH""",
    "-m",
    """$MAINMODULE"""
)
Exec-Cmd("$env:JAVA_HOME\bin\java.exe", $JAVA_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
