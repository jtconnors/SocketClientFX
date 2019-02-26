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
# Create a module-path for the java command.  It either includes the classes
# in the $TARGET directory or the $TARGET/$MAINJAR (if it exists) and the
# $EXTERNAL_MODULES defined in env.sh.
#
if [ -f $TARGET/$MAINJAR ]
then
	MODPATH=$TARGET/$MAINJAR
else
	MODPATH=$TARGET
fi
for ((i=0; i<${#EXTERNAL_MODULES[@]}; i++ ))
do
    MODPATH=${MODPATH}":""${EXTERNAL_MODULES[$i]}"
done

exec_cmd "java --module-path $MODPATH -m $MAINMODULE/$MAINCLASS"
