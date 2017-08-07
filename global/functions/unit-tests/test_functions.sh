#!/bin/sh
. ../functions/functions.sh

# unit tests

# first cat the file
echo "original test.txt"
cat ./test.txt


# test replace_line_string

echo "---"
echo "testing replace"

replace_line_string first ./test.txt noice

cat ./test.txt
echo "--"

# test get_line
echo "testing get line (second)"
linez=$(get_line second ./test.txt)
echo $linez

echo "---"
cat ./test.txt
echo "---"

# test prepend line
echo "testing prepend"
prepend_line ./test.txt $linez \#

cat ./test.txt
echo "---"

# test prepend_everything_after
echo "testing prepend_everything_after"
prepend_everything_after ./test.txt $linez \#

cat ./test.txt

# retset test.txt
cp ./test.txt.bak ./test.txt

