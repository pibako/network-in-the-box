#!/bin/sh
#
# FILENAME: cleanupzone.sh
#
# Usage: cleanupzone.sh <zone name>
#
# This will completely remove a zone from the system
#
if [ $# != 1 ]
then
    echo "Usage: cleanupzone <zone name>"
exit 1
fi
echo 'zoneadm -z '$1' halt'
zoneadm -z $1 halt
echo 'zoneadm -z '$1' uninstall -F'
zoneadm -z $1 uninstall -F
echo 'zonecfg -z '$1' delete -F'
zonecfg -z $1 delete -F

#
# END FILE cleanupzone.sh
