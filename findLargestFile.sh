#!/bin/bash

getFileSizeInByte() {
	echo $( wc -c $1 | cut -d ' ' -f 1)
}

analyzeFile() {
	local size=$(getFileSizeInByte $1)
	if [ $size -gt $maxFileSize ]; then
		largestFile=$1
		maxFileSize=$size
	fi
}

modifyMaxFileSize() {
	local byte=1
	local kB=$(( 1000 * $byte))
	local MB=$(( 1000 * $kB))
	local GB=$(( 1000 * $MB))
	local TB=$(( 1000 * $GB))

	local unit="byte"
	local unitDivider=1

	if [ $maxFileSize -ge $kB ] && [ $maxFileSize -lt $MB ]; then
		unit="kB"
		unitDivider=$kB
	elif [ $maxFileSize -ge $MB ] && [ $maxFileSize -lt $GB ]; then
		unit="MB"
		unitDivider=$MB
	elif [ $maxFileSize -ge $GB ] && [ $maxFileSize -lt $TB ]; then
		unit="GB"
		unitDivider=$GB
	elif [ $maxFileSize -ge $TB ]; then
		unit="TB"
		unitDivider=$TB
	fi

	maxFileSize=$(bc <<< "scale=2; $maxFileSize/$unitDivider")
	maxFileSize="$maxFileSize $unit"
}

printReuslts() {
	modifyMaxFileSize
	echo " >>> RESULT <<< "
	echo " File: "
	echo "$largestFile "
	echo " Size: "
	echo "$maxFileSize"
}

echo " >>> Trying to find the largest file.."
readonly OIFS="$IFS"
IFS=$'\n'

maxFileSize=0
largestFile=''
directory='.'

if [ $# -eq 1 ]; then
	directory="$1"
elif [ $# -gt 1 ]; then
	echo ' >>> This command works with up to 1 argument.'
	exit 1
fi
echo " >>> Searching in directory: $directory "

for file in $(find $directory -type f);
do
	analyzeFile "$file"
done

printReuslts

IFS="$OIFS"
# returning 0 -> indicating success
exit 0