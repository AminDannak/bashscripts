#!/bin/bash

# Variable BitRate (VBR): 
# specifies the value of VBR quality 
# (default = 4, best quality = 0)
# when VBR is used in the 'lame' command, '-h' switch is also
# implicitly enabled, so we don't need to explicitly set it.
VBR=0

# Constant BitRate (CBR)
CBR=320

function setDirectory() {
	directory='.'
	if [ $# -eq 1 ]; then
		directory=$1
	elif [ $# -gt 1 ]; then
		echo "$0: you can run this command with 1 or no arguments"
	fi
	echo " --- target directory: $directory"
}

function checkLame() {
	hash lame
	if [ $? -eq 1 ]; then
		# lame is not installed
		echo "plz install 'lame' first (sudo apt-get install lame)"
		reurn 1
	fi
}

checkLame
setDirectory
OIFS=$IFS
IFS='\n'
pushd $directory
for f in *.wav; do 
	lame -V $VBR -b $CBR "${f}" "${f%.wav}.mp3"
done
IFS=$OIFS
popd
