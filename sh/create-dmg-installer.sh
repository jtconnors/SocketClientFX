#!/bin/bash

#
# Move to the directory containing this script so we can source the env.sh
# properties that follow
#
cd `dirname $0`

#
# Common properties shared by scripts
#
. env.sh

exec_cmd "$JPACKAGE_HOME/bin/jpackage --name $LAUNCHER $VERBOSE_OPTION --module-path $MODPATH --module $MAINMODULE/$MAINCLASS"
