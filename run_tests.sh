#!/bin/sh

# download shunit2 in order to run tests:
# curl -L "https://dl.dropboxusercontent.com/u/7916095/shunit2-2.0.3.tgz" | tar zx --overwrite

./test/test_suite.sh 2>&1 | tr '\r' '\n' > test.log
cat test.log
cat test.log | grep -q 'success rate: 100%'
