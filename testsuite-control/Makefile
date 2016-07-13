SUITE = ${DESTDIR}/var/lib/slenkins/tests-squid

all:

install: nodes run.py
	mkdir -p ${SUITE}/tests-control/bin
	cp nodes ${SUITE}/tests-control/
	cp run.py ${SUITE}/tests-control/bin/
	chmod +x ${SUITE}/tests-control/bin/*.py
