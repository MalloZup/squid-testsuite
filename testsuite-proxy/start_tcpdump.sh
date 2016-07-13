#! /bin/bash

TRANSFER_TYPE=$1

echo "+++++++++++++++++++++++"
echo "+ SNIFFING ON PROXY   +"
echo "+++++++++++++++++++++++"

# Start tcpdump in background
# -U             buffered on a packet basis
# -c9            the test with index.html sends 9 packets, so we stop after 9 packets
# -w "http_log"  write to file
# -i eth0        capture on interface eth0
# port 3128      capture on squid port 3128
echo -n "SETUP: we sniff on eth0 interface: "
capture_file="/tmp/squid-${TRANSFER_TYPE}-traffic.pcap"
tcpdump -U -c9 -w "$capture_file" -i eth0 port 3128 >/tmp/stdout 2>/tmp/stderr </dev/null &
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi

