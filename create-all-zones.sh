#!/bin/sh
#
# Usage: create-all-zones.sh
#
# This script will create 4 zones: routing, proxy, db and web.
#

# Create reverse proxy zone
./create-zone-1vnic.sh zproxy1 vproxy1 zproxy1 10.0.5.1

# Create router zone
./create-zone-4vnic.sh zrouter1 vglob0 zrouter1-vglob0 10.0.8.254 vproxy0 zrouter1-vproxy0 10.0.5.254 vdb0 zrouter1-vdb0 10.0.7.254 vweb0 zrouter1-vweb0 10.0.6.254

# Create web 1 zone
./create-zone-1vnic.sh zweb1 vweb1 zweb1 10.0.6.1

# Create db 1 zone
./create-zone-1vnic.sh zdb1 vdb1 zdb1 10.0.7.1

#
# END FILE create-all-zones.sh
