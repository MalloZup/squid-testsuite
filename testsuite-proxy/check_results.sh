#! /bin/bash

check_log ()
{
  error_type="$1"
  file_name="$2"

  echo -n "TEST: searching for ${error_type} errors in ${file_name} log file: "
  # insensitive, context lines 10, line number in file
  grep -i $error_type -C 10 -n $file_name > /tmp/check_log.slenkins
  if [ $? -eq 0 ]; then
    echo "FOUND ERROR $error_type"
    cat /tmp/check_log.slenkins
    echo "PACKAGE VERSION:"
    rpm -qv squid
    exit 2
  else
    echo "OK"
  fi
}

TRANSFER_TYPE=$1

SUITE='/var/lib/slenkins/tests-squid/tests-proxy'

echo "++++++++++++++++++++++++"
echo "+ CHECKING THE RESULTS +"
echo "++++++++++++++++++++++++"

# Wait one second to leave time for transfer to complete
sleep 1

# Analyze capture, encrypted or not encrypted traffic
# For https, "Fortune" is not found, for http it is found
echo -n "TEST: ${TRANSFER_TYPE} traffic: "
tcpdump -n -A -r /tmp/squid-${TRANSFER_TYPE}-traffic.pcap 2>/dev/null | grep "Fortune"
rc=$?
if [ "$TRANSFER_TYPE" = "https" ]; then
  if [ $rc -ne 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi
else
  if [ $rc -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi
fi

# Analyze logs
echo "ACCESS LOG:"
cat /var/log/squid/access.log
echo
for error_type in fatal error warning security; do
  check_log $error_type /var/log/squid/cache.log
done
