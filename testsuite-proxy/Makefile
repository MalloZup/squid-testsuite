SUITE = ${DESTDIR}/var/lib/slenkins/tests-squid

all:

install: configure_squid.sh start_tcpdump.sh check_results.sh
	mkdir -p ${SUITE}/tests-proxy/bin
	cp *.sh ${SUITE}/tests-proxy/bin/
