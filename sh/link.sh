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

exec_cmd "jlink $VERBOSE_OPTION --module-path $MODPATH --add-modules $MAINMODULE --compress=2 --launcher $LAUNCHER=$MAINMODULE/$MAINCLASS --output $IMAGE"
