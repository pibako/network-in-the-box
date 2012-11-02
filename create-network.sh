#!/bin/sh
#
# Usage: create-network.sh
#
# This will create the crossbow network-in-a-box
# VNICs and etherstubs
#

dladm create-etherstub globalswitch0
dladm create-vnic -l globalswitch0 vglob0
dladm create-vnic -l globalswitch0 vglob1

dladm create-etherstub proxyswitch0
dladm create-vnic -l proxyswitch0 vproxy0
dladm create-vnic -l proxyswitch0 vproxy1

dladm create-etherstub webswitch0
for i in {0..3}; do
    dladm create-vnic -l webswitch0 vweb$i;
done

dladm create-etherstub dbswitch0
for i in {0..3}; do
    dladm create-vnic -l dbswitch0 vdb$i;
done

#
# END FILE create-network.sh
