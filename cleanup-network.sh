#!/bin/sh
#
# Usage: cleanup-network.sh
#
# This will completely remove the crossbow network-in-a-box
# VNICs and etherstubs
#

dladm delete-vnic vglob0
dladm delete-vnic vglob1
dladm delete-vnic vproxy0
dladm delete-vnic vproxy1
for i in {0..3}; do
    dladm delete-vnic vweb$i;
done
for i in {0..3}; do
    dladm delete-vnic vdb$i;
done

dladm delete-etherstub globalswitch0
dladm delete-etherstub proxyswitch0
dladm delete-etherstub webswitch0
dladm delete-etherstub dbswitch0

#
# END FILE cleanup-network.sh
