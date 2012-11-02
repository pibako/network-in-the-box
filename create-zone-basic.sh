#!/bin/bash -x
if [ $# != 1 ] 
then
    echo "Usage: create-zone-basic.sh <zonename>"
    exit 1
fi 

ZONENAME=$1

zonecfg -z $ZONENAME "create; set zonepath=/zones/$ZONENAME"
zonecfg -z $ZONENAME "set ip-type=exclusive"
zonecfg -z $ZONENAME "verify"
zonecfg -z $ZONENAME "commit"

zoneadm -z $ZONENAME install
zoneadm -z $ZONENAME boot
