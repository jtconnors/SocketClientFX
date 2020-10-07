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

exec_cmd "$JPACKAGE_HOME/bin/jpackage --type app-image --vendor $VENDOR_STRING $VERBOSE_OPTION --name $LAUNCHER --module $MAINMODULE/$MAINCLASS --runtime-image $IMAGE"
