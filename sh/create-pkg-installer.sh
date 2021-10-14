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
TYPE=pkg
if [ "$PLATFORM" != "mac" ]
then
	echo "Cannot create package type '$TYPE' on $PLATFORM platform"
        exit 1
fi

exec_cmd "$JPACKAGE_HOME/bin/jpackage --type $TYPE --vendor $VENDOR_STRING --icon src/main/resources/dukeicon.icns --name $LAUNCHER $VERBOSE_OPTION --module-path $MODPATH --module $MAINMODULE/$MAINCLASS"
