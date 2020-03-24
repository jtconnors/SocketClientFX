
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
Set-Variable -Name JLINK_ARGS -Value @(
    '--module-path',
    """$MODPATH""",
    "--add-modules",
    """$MAINMODULE""",
    '--compress=2',
    '--launcher',
    """$LAUNCHER=$MAINMODULE/$MAINCLASS""",
    '--output',
    """$IMAGE"""
)
if ($VERBOSE_OPTION -ne $null) {
   $JLINK_ARGS += '--verbose'
}
Exec-Cmd("jlink.exe", $JLINK_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
