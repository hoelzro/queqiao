#!/bin/sh

which runVimTests.sh >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
    echo "You need runVimTests.sh installed to run the test suite"
    echo "http://www.vim.org/scripts/script.php?script_id=2565"
    exit
fi

if [[ "x$1" == "xclean" ]]; then
    rm tests/*.msgout
    rm tests/*.msgresult
elif [[ "x$1" != "x" ]]; then
    runVimTests.sh --pure "$1"
else
    runVimTests.sh --pure tests/
fi
