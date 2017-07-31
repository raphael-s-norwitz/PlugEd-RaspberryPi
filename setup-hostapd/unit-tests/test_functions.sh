#!/bin/sh

# functions:

# first param: line to replace
# second param: file to replace it in
# should be ONLY 1 occurance in file
replace_line_string () {
	if [ -z "$1" ];
	then
		echo "missing args"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing second arg"
		return 1
	fi

	# args
	toreplace="$1"
	file="$2"
	newline="$3"
	filetmp="$2.shcp.tmp"

	# get line number
	linenum=$(grep -n "$1" $2 | awk -F: 'NR==1{print $1}')

	# copy file
	cp $file $filetmp
	
	# replace line and go to original file
	awk -v num="$linenum" -v to="$newline" 'NR==num {$0=to} 1' $filetmp > $file

	# remove intermediate file
	rm $filetmp

	return 0
}

# first is the string to find
# sencond if the file
get_line () {
	if [ -z "$1" ];
	then
		echo "missing args"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing second arg"
		return 1
	fi
	
	tofind="$1"
	file="$2"

	# find line number
	grep -n "$tofind" $file | awk -F: 'NR==1{print $1}'
	
	return 0
}

# put value in front
prepend_line () {
	repstr="#"

	if [ -z "$1" ];
	then
		echo "missing line number"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing file"
		return 1
	elif [ -z "$3" ];
	then
		repstr="$3"
	fi

	line="$2"
	file="$1"
	filetmp="$1.tmp"

	# get tmp
	cp $file $filetmp

	awk -v linenum="$line" -v rstr="$repstr" 'NR==linenum {$0=rstr$0} 1' $filetmp > $file
	
	rm $filetmp

	return 0
}

prepend_everything_after () {
	repstr="#"

	if [ -z "$1" ];
	then
		echo "missing line number"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing file"
		return 1
	elif [ -z "$3" ];
	then
		repstr="$3"
	fi

	line="$2"
	file="$1"
	filetmp="$1.tmp"

	# get tmp
	cp $file $filetmp

	awk -v linenum="$line" -v rstr="$repstr" 'NR >= linenum {$0=rstr$0} 1' $filetmp > $file
	
	rm $filetmp

	return 0
}


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

