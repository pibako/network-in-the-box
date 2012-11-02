#!/bin/bash -x
if [ $# != 4 ] 
then
    echo "Usage: createzone-1vnic.sh <zonename> <vnic1> <hostname for vnic1> <ip addr for vnic1>"
    exit 1
fi 
ZONENAME=$1
VNIC1=$2
VNIC1HOSTNAME=$3
VNIC1IP=$4
echo "Create zone $ZONENAME" with 
echo " Interface $VNIC1, hostname $VNIC1HOSTNAME at IP Address $VNIC1IP"

zonecfg -z zclone export | zonecfg -z $ZONENAME -f - 
zonecfg -z $ZONENAME "set zonepath=/zones/$ZONENAME"

# add the VNIC
zonecfg -z $ZONENAME "add net;set physical=$VNIC1;end"
# add autoboot flag
zonecfg -z $ZONENAME "set autoboot=true; end"

# now create the new zone from the zclone (template zone)
zoneadm -z $ZONENAME clone zclone

# For ZFS based zones, you have to 'ready' them to see the zone's file 
# system from the global zone.
zoneadm -z $ZONENAME ready

# Note, you can not generate a root password under OpenSolaris
# and use that encrypted string for the root_password property.
# The work around is to generate a password on Solaris 10 instead, 
# and use that encryption (from /etc/shadow) for the root_password 
# setting.

HASHED_ROOT_PASSWORD='hashed_root_password'

cat > /zones/$ZONENAME/root/etc/sysidcfg << _EOF_ 
terminal=vt100 
timezone=Europe/Warsaw
nfs4_domain=dynamic 
security_policy=NONE
root_password=$HASHED_ROOT_PASSWORD
network_interface=PRIMARY { 
hostname=$VNIC1HOSTNAME 
ip_address=$VNIC1IP
netmask=255.255.255.0 
protocol_ipv6=no 
default_route=none
}
name_service=NONE 
_EOF_

# boot new zone
zoneadm -z $ZONENAME boot

