#!/bin/sh

SB_DIR=__sb

FILES=`git show --pretty='format:' --name-only HEAD`

exec "$SB_DIR"/build $FILES
