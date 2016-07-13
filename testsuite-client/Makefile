SUITE = ${DESTDIR}/var/lib/slenkins/tests-squid

all:

install: no_direct.sh http_transfer.sh https_transfer.sh
	mkdir -p ${SUITE}/tests-client/bin
	cp *.sh ${SUITE}/tests-client/bin/
