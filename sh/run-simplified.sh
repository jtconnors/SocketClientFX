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
# Create a module-path for the java command.  It includes target/$MAINJAR
# and the $EXTERNAL_MODULES defined in env.sh.
#
MODPATH=$TARGET/$MAINJAR
for ((i=0; i<${#EXTERNAL_MODULES[@]}; i++ ))
do
    MODPATH=${MODPATH}":""${EXTERNAL_MODULES[$i]}"
done

#
# Have to manually specify main class via jar --update until
# maven-jar-plugin 3.1.2+ is released
if [ ! -f $TARGET/$MAINJAR ] ; then
	echo "Did you run 'mvn package' first?"
	exit 1
fi
JARCMD="jar --main-class $MAINCLASS --update --file $TARGET/$MAINJAR"
exec_cmd $JARCMD
echo

exec_cmd "java --module-path $MODPATH -m $MAINMODULE/$MAINCLASS"
