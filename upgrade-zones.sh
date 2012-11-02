#!/bin/sh
#
# Usage: upgrade-zones.sh zrouting1 zproxy1 zdb1 zweb1
#
# This script will configure nsswitch for dns lookup
#

for ZONENAME in $*
do
    # halt the zone
    zoneadm -z $ZONENAME halt 
    # upgrade it
    pkg -R /zones/$ZONENAME/root/ image-update
    # boot it again
    zoneadm -z $ZONENAME boot;

done

#
# END FILE upgrade-zones.sh
