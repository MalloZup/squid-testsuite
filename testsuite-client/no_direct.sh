#! /bin/bash

IP_SERVER_INT=$1

echo "++++++++++++++++++++++++++++"
echo "+ CHECK DIRECT CONNECTIONS +"
echo "++++++++++++++++++++++++++++"

echo -n "SETUP: checking that CLIENT cannot reach SERVER directly on internal address: "
ping -c 1 $IP_SERVER_INT
if [ $? -ne 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi
echo
