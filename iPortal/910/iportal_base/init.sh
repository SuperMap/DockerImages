#!/bin/bash -e

[[ -z "$LICENSE_SERVER" ]] && LICENSE_SERVER="localhost"
sed -i "s/{serveraddr}/$LICENSE_SERVER/g" /etc/hasplm/hasplm.ini

cd /opt/aksusbd
./dunst
./dinst
echo

echo "'docker run -e LICENSE_SERVER=192.168.17.123 **' can be used to config the license now."
echo " or PUT mylicense.lic to $LICENSE_DIR directory"