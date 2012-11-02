#!/bin/sh
#
# Usage: post-install-fix.sh zrouting1 zproxy1 zdb1 zweb1
#
# This script will configure nsswitch for dns lookup
#

for ZONENAME in $*
do
    # fix certificate issue
    zlogin $ZONENAME "mkdir -p /etc/curl && cat /etc/certs/CA/*.pem > /etc/curl/curlCA"

    # copy nsswitch.dns to .conf
    cp /zones/$ZONENAME/root/etc/nsswitch.dns /zones/$ZONENAME/root/etc/nsswitch.conf

    # add dns addresses
    cat > /zones/$ZONENAME/root/etc/resolv.conf << _EOF_ 
nameserver 8.8.8.8
nameserver 8.8.4.4
_EOF_
done

#
# END FILE post-install-fix.sh
