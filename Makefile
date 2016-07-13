all:

install:
	make -C data install
	make -C testsuite-control install
	make -C testsuite-client install
	make -C testsuite-server install
	make -C testsuite-proxy install
