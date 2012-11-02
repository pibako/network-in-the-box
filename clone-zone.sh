#!/bin/bash -x
if [ $# != 5 ] 
then
    echo "Usage: clonezone.sh <source zonename> <zonename> <vnic1> <hostname for vnic1> <ip addr for vnic1>"
    exit 1
fi 
SOURCEZONENAME=$1
ZONENAME=$2
VNIC1=$3
VNIC1HOSTNAME=$4
VNIC1IP=$5
echo "Create zone $ZONENAME" with 
echo " Interface $VNIC1, hostname $VNIC1HOSTNAME at IP Address $VNIC1IP"

zonecfg -z $SOURCEZONENAME export | zonecfg -z $ZONENAME -f - 
zonecfg -z $ZONENAME "set zonepath=/zones/$ZONENAME"

# remove all VNIC's
zonecfg -z $ZONENAME "remove net;end"
# add the VNIC
zonecfg -z $ZONENAME "add net;set physical=$VNIC1;end"
# add the /usr loopback file systems
# zonecfg -z $ZONENAME "add fs;set type=lofs; set dir=/usr; set special=/usr; end"
# add the /opt loopback file systems
# zonecfg -z $ZONENAME "add fs;set type=lofs; set dir=/opt; set special=/opt; end"
# enable dtrace in zones
zonecfg -z $ZONENAME "set limitpriv=default,dtrace_user,dtrace_proc"

# set maximum nr of light-weight processes
zonecfg -z $ZONENAME "set max-lwps=1000" 
# set nr of shares for zone (can be omitted)
zonecfg -z $ZONENAME "set cpu-shares=1"
# set maximum nr of processor time used by processes in this zone
zonecfg -z $ZONENAME "add capped-cpu; set ncpus=1; end"
# set maximum memory allocated, swapped and locked
zonecfg -z $ZONENAME "add capped-memory; set physical=1024m; set swap=1024m; set locked=10m; end"

# now create the new zone from the instance
zoneadm -z $ZONENAME clone $SOURCEZONENAME
#
# For ZFS based zones, you have to 'ready' them to see the zone's file 
# system from the global zone.
zoneadm -z $ZONENAME ready

# Note, you can not generate a root password under OpenSolaris
# and use that encrypted string for the root_password property.
# The work around is to generate a password on Solaris 10 instead, 
# and use that encryption (from /etc/shadow) for the root_password 
# setting.
 
ROOT_PASSWORD='hashed_root_password'

cat > /zones/$ZONENAME/root/etc/sysidcfg << _EOF_ 
terminal=vt100 
timezone=Europe/Warsaw
nfs4_domain=dynamic
security_policy=NONE
root_password=$ROOT_PASSWORD
name_service=NONE
network_interface=PRIMARY { 
hostname=$VNIC1HOSTNAME 
ip_address=$VNIC1IP
netmask=255.255.255.0 
protocol_ipv6=no 
default_route=none
}
name_service=NONE 
_EOF_

cat > /zones/$ZONENAME/root/etc/resolv.conf << _EOF_ 
domain $ZONENAME.pirakoko.com
nameserver 8.8.8.8
nameserver 8.8.4.4
_EOF_

cp -f /zones/$ZONENAME/root/etc/nsswitch.dns /zones/$ZONENAME/root/etc/nsswitch.files

zoneadm -z $ZONENAME boot
