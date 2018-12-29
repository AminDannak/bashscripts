#!/bin/bash

# looks into the working directory and its sub-directories
# and removes any file with a format other than the one 
# given to it as an argument.

if [[ $# == 0 ]] ; then
	echo "$0: you should specify a file format."
	exit 1
elif [[ $# > 1 ]]; then
	echo "$0: you can only specify a single file format."
	exit 1
fi

find . -type f -not -name "*.$1" -delete
exit 0
