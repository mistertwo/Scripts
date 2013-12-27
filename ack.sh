#!/bin/bash
ack-grep --nosql "root" * > ack.txt
nl ack.txt
awk -F':' '{print $1}' ack.txt > file.txt
awk -F':' '{print $2}' ack.txt > line.txt
#pick=$(sed -n 2p ack.txt)
echo -n "Which File? "
read which
pick=$(sed -n "$which"p file.txt)
pickline=$(sed -n "$which"p line.txt)
nano +$pickline $pick
