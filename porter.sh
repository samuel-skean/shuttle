#!/usr/bin/env bash

# This program "chunks" its input based on newlines in it, sending the next bit
# of input (*without* the newlines) only when it gets a character or "EOF"
# (zero-length read) from standard in. Not being able to send newlines is
# *giant* limitation.
#
# I do not call it "chunk" because, as always, "files" in unix should always be
# seen as streams, with the amount transferred in a given operation, i.e. call
# to `read()`/`write()`, not being semantically relevant. This program is only
# about controlling the *timing* of `write()`s, though it will have effects on
# the amount of data sent in one operation.
#
# Think of it as a porter who carries your data, and only goes when you say go.

if test $# -ne 1
then
    echo "Usage: ./shuttle.sh <filename>"
    exit 255
fi
set -ue # Fail on accessing unset variables, fail on first erroring command.

exec 3< "$1"

while read -N 1
do
    read -u 3
    echo -n "${REPLY}"
done
