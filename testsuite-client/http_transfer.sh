#! /bin/bash

PROXY=$1
SERVER=$2

SUITE='/var/lib/slenkins/tests-squid/tests-client'

echo "+++++++++++++++++++++++"
echo "+ HTTP PROXY TESTING  +"
echo "+++++++++++++++++++++++"

echo -n "TEST: can transfer file from CLIENT to SERVER through PROXY: "
wget -e use_proxy=yes -e http_proxy=$PROXY:3128 --output-document /tmp/index.html http://$SERVER/index.html
if [ $? -eq 0 ]; then echo ""; else echo "FAILED"; exit 1; fi

echo -n "TEST: integrity - compare checksums between download and original: "
sum_original="$(sha256sum ${SUITE}/data/index.html | cut -d' ' -f1)"
sum_download="$(sha256sum /tmp/index.html | cut -d' ' -f1)"
if [ "$sum_original" = "$sum_download" ]; then echo "OK"; else echo "FAILED"; exit 1; fi
