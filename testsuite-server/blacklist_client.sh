#! /bin/bash

IP_CLIENT_INT=$1
IP_CLIENT_EXT=$2

echo "+++++++++++++++++++++++++++++"
echo "+ FORBID DIRECT CONNECTIONS +"
echo "+++++++++++++++++++++++++++++"

echo -n "SETUP: refuse any connection from CLIENT internal IP to SERVER: "
iptables -A INPUT -s $IP_CLIENT_INT -j REJECT
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi

echo -n "SETUP: refuse any connection from CLIENT external IP to SERVER: "
iptables -A INPUT -s $IP_CLIENT_EXT -j REJECT
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 2; fi

