Set-variable -Name CMDLINE_ARGS -Value $args

& {      
    #
    # Move to the directory containing this script so we can source the env.ps1
    # properties that follow
    #
    cd $PSScriptRoot
    
    #
    # Common properties shared by scripts
    #
    . .\env.ps1
    
    #
    # Run the Java command
    #
    Set-Variable -Name JPACKAGE_ARGS -Value @(
        'create-image',
        '--runtime-image',
        """$IMAGE""",
        "--input",
        """$TARGET""",
        '--output',
        """$APPIMAGE""",
        '--name',
        """$LAUNCHER""",
        '--main-jar',
        """$MAINJAR"""
    )
    if ($VERBOSE_OPTION -ne $null) {
       $JPACKAGE_ARGS += '--verbose'
    }
    Exec-Cmd("$JPACKAGE_HOME\bin\jpackage.exe", $JPACKAGE_ARGS)
}