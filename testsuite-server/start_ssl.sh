#! /bin/bash

IP_SERVER="$1"

SUITE='/var/lib/slenkins/tests-squid/tests-server'

echo "+++++++++++++++++++++++++++++"
echo "+ CONFIGURE APACHE2 SERVER  +"
echo "+++++++++++++++++++++++++++++"

if [ -f /proc/sys/crypto/fips_enabled ]; then
  fips_enabled=$(cat /proc/sys/crypto/fips_enabled)
  echo "INFO: FIPS enabled: $fips_enabled"
else
  echo "INFO: no FIPS support in kernel"
fi

echo -n "SETUP: generating dummy certificate: "
gensslcert -n $IP_SERVER &>/dev/null
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 1; fi

echo -n "SETUP: checking that SSL is already installed: "
msg=$(a2enmod ssl)
if [ "$msg" = '"ssl" already present' ]; then echo "OK"; else echo $msg; exit 2; fi

echo -n "SETUP: enabling SSL in Apache: "
a2enflag SSL &>/dev/null
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 3; fi

echo "SETUP: using our own config files"
cd /etc/apache2
cp httpd.conf httpd.conf.test
sed -i 's/Include .*ssl-global\.conf/\# &/' httpd.conf.test
cp ${SUITE}/data/vhost-ssl.conf vhosts.d/
sed -i 's:APACHE_HTTPD_CONF=".*":APACHE_HTTPD_CONF="/etc/apache2/httpd.conf.test":' /etc/sysconfig/apache2

echo "SETUP: installing index.html"
cp ${SUITE}/data/index.html /srv/www/htdocs/

echo -n "SETUP: starting Apache: "
rcapache2 start
if [ $? -eq 0 ]; then echo "OK"; else echo "FAILED"; exit 4; fi
