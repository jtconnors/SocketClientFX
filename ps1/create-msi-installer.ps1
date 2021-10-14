
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
Set-Variable -Name JPACKAGE_ARGS -Value @(
    '--name',
    """$LAUNCHER""",
    '--type',
    'msi',
    '--vendor',
    """$VENDOR_STRING""",
    '--win-shortcut',
    '--icon',
    'src/main/resources/dukeicon.ico',
    '--module-path',
    """$MODPATH""",
    '--module',
    """$MAINMODULE/$MAINCLASS"""
)
if ($VERBOSE_OPTION -ne $null) {
   $JPACKAGE_ARGS += '--verbose'
}
Exec-Cmd("$JPACKAGE_HOME\bin\jpackage.exe", $JPACKAGE_ARGS)

#
# Return to the original directory
#
cd $STARTDIR
