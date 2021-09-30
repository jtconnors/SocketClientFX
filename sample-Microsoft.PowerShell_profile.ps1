#
# Sample Microsoft.PowerShell_profile.ps1 file. This will
# set the PowerShell environment at PowerShell start up.
#
# This file can be:
# o renamed to Microsoft.PowerShell_profile.ps1 and placed in the
#   User's Documents\WindowsPowerShell directory
# o edited to reflect your JDK environment
#

$env:PATH = 'd:\openjdk\jdk-17\bin;' + $env:PATH
$env:JAVA_HOME = 'd:\openjdk\jdk-17'
