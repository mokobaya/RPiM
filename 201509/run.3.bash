#!/bin/bash

trap 'exit 0' 1

abort () {
	###止める###
	echo 0 | tee /dev/rtmotoren0 /dev/rtled? 
	echo ABORT >&2
	exit 1
}

###壁が近づくと止める処理###
: > /tmp/warning
while sleep 0.1 ; do
	cat /dev/rtlightsensor0		|
	awk '$1+$2+$3+$4>400{print "STOP"}' > /tmp/warning
	[ -s /tmp/warning ] && abort
done &

###前進###
seq 1 20					|
awk '{print $1*100;system("sleep 0.1")}'	|
tee /dev/rtmotor_raw_?0 
