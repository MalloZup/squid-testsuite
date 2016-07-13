SUITE  = ${DESTDIR}/var/lib/slenkins/tests-squid


all:

install: start_ssl.sh blacklist_client.sh
	mkdir -p ${SUITE}/tests-server/bin/
	cp *.sh ${SUITE}/tests-server/bin/

