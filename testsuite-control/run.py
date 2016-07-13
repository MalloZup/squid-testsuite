#! /usr//bin/python

import sys
import traceback
import twopence
import susetest
from susetest_api.assertions import *
from susetest_api.files import *
from susetest_api.log import *

import suselog

journal = None
suite = "/var/lib/slenkins/tests-squid"
client = None
server = None
proxy = None

def setup():
    global client, server, proxy,  journal

    config = susetest.Config("tests-squid")
    journal = config.journal

    proxy = config.target("proxy")
    client = config.target("client")
    server = config.target("server")
###
# *** testcases 
##

# testcase : squid cache delete.

def cache_delete():
	journal.beginGroup("configuring squid: server, proxy, client")
	run_cmd(proxy, "systemctl stop squid && squid -z && systemctl start quid", " delete squid cache test", 699) 
	run_cmd(proxy, "{0}/tests-proxy/bin/check_results.sh https".format(suite), "Check result for http test", time_out=700)

def conf_squid():
	journal.beginGroup("configuring squid: server, proxy, client")
	run_cmd(server, "{0}/tests-server/bin/start_ssl.sh {1}".format(suite, server.ipaddr), "configure ssl apache2", time_out=700)
	run_cmd(server, "{0}/tests-server/bin/blacklist_client.sh {1} {2}".format(suite, client.ipaddr, server.ipaddr), "refuse direct connection from client to server", time_out=700)
	run_cmd(client, "{0}/tests-client/bin/no_direct.sh {1}".format(suite, server.ipaddr), "test no connect. from client to server" , time_out=700)
	run_cmd(proxy, "{0}/tests-proxy/bin/configure_squid.sh".format(suite),  "configure squid" , time_out=700)

def test_squid():
        journal.beginGroup("Test HTTP transfers from client to server through proxy")
	run_cmd(proxy, "{0}/tests-proxy/bin/start_tcpdump.sh http".format(suite), "configure ssl apache2", time_out=700)
	run_cmd(client, "{0}/tests-client/bin/http_transfer.sh {1} {2}".format(suite, proxy.ipaddr, server.ipaddr), "http testing", time_out=700)
	run_cmd(proxy, "{0}/tests-proxy/bin/check_results.sh http".format(suite), "Check result for http test", time_out=700)
        run_cmd(proxy, "{}/tests-proxy/bin/start_tcpdump.sh https".format(suite), "tcpdump for https", time_out=700)
        run_cmd(client, "{}/tests-client/bin/https_transfer.sh {} {}".format(suite, proxy.ipaddr, server.ipaddr), "https testing")
	run_cmd(proxy, "{0}/tests-proxy/bin/check_results.sh https".format(suite), "Check result for http test", time_out=700)
####
#  MAIN_PROGRAM
####
setup()

try:
	conf_squid()
	test_squid()
	cache_delete()
#        systemd_check(proxy)
except:
    print "Unexpected error"
    journal.info(traceback.format_exc(None))
    raise

susetest.finish(journal)
