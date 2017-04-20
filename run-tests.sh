#!/usr/bin/env bash

if [ -z "$EMACS" ] ; then
    EMACS="emacs"
fi

$EMACS -batch -l markup.el -l markup-test.el -f ert-run-tests-batch-and-exit
