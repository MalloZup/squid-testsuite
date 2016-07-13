SUITE = ${DESTDIR}/var/lib/slenkins/tests-squid

all:

install: squid.conf vhost-ssl.conf index.html
	mkdir -p ${SUITE}/tests-client/data
	mkdir -p ${SUITE}/tests-proxy/data
	mkdir -p ${SUITE}/tests-server/data
	cp index.html ${SUITE}/tests-client/data/
	cp squid.conf ${SUITE}/tests-proxy/data/
	cp vhost-ssl.conf index.html ${SUITE}/tests-server/data
