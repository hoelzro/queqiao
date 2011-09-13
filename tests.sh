#!/bin/sh

which runVimTests.sh >/dev/null 2>&1

if [[ $? -eq 0 ]]; then
    runVimTests.sh --pure tests/
else
    echo "You need runVimTests.sh installed to run the test suite"
    echo "http://www.vim.org/scripts/script.php?script_id=2565"
fi