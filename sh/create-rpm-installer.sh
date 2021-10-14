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

#
# Non-native package builds are not supported
#
TYPE=rpm
if [ "$PLATFORM" != "linux" ]
then
	echo "Cannot create package type '$TYPE' on $PLATFORM platform"
        exit 1
fi

exec_cmd "$JPACKAGE_HOME/bin/jpackage --type $TYPE --vendor $VENDOR_STRING --icon src/main/resources/duke64x64.png --name $LAUNCHER $VERBOSE_OPTION --module-path $MODPATH --module $MAINMODULE/$MAINCLASS"
