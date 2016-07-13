#! /bin/bash

SUITE='/var/lib/slenkins/tests-squid/tests-proxy'

set -e 

echo "++++++++++++++++++++++++"
echo "+ CONFIGURING SQUID    +"
echo "++++++++++++++++++++++++"

hostmachine=`hostname`

sed -i "s/visible_hostname slenkins-machine/visible_hostname $hostmachine/g" /etc/squid/squid.conf
echo "SETUP: installing squid config file"
cp $SUITE/data/squid.conf /etc/squid

# Start squid
echo -n "SETUP: we start squid proxy: "
systemctl start squid
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi

