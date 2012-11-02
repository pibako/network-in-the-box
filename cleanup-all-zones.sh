#!/bin/sh
#
# Usage: cleanup-all-zones.sh
#
# This will completely remove all the crossbow demo zones
#

sh cleanupzone.sh zweb1
sh cleanupzone.sh zrouter1
sh cleanupzone.sh zdb1
sh cleanupzone.sh zproxy1

#
# END FILE cleanup-all-zones.sh
