#!/bin/sh

which runVimTests.sh >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
    echo "You need runVimTests.sh installed to run the test suite"
    echo "http://www.vim.org/scripts/script.php?script_id=2565"
    exit
fi

if ! readlink -f /dev/null &>/dev/null ; then
    echo "You need GNU readlink to use runVimTests"
    echo "If you're on Mac OS X and are using homebrew, you can install the coreutils package"
    echo "If you're not, please let me know how you install this tool so I can put it in this message =)"
    exit
fi

echo Hello > tmp
sed -n 'p' -- tmp &>/dev/null
sed_status=$?
rm tmp

if [[ $sed_status -ne 0 ]]; then
    echo "You need GNU sed to use runVimTests"
    echo "If you're on Mac OS X and are using homebrew, you can install the gnu-sed package (and create a symbolic link sed -> gsed in your PATH)"
    echo "If you're not, please let me know how you install this tool so I can put it in this message =)"
    exit
fi

if [[ "x$1" == "xclean" ]]; then
    rm -f tests/*.msgout
    rm -f tests/*.msgresult
    rm -f tests/*.out
elif [[ "x$1" != "x" ]]; then
    runVimTests.sh --pure "$1"
else
    runVimTests.sh --pure tests/
fi
