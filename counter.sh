#/bin/bash

#while [[ $num != x ]]; do
		
		#for pick in $(sed -n "$num"p find.txt); do ssh -t bmoore_@$account.wpengine.com "cd /nas/wp/www/$envir/$account && sudo nano $pick && exit ; bash" done
		#if [[ -n $num ]]; then
#			site=$(sed -n "$num"p sites.txt)
#			ssh -t bmoore_@$account.wpengine.com "sudo /nas/wp/admin deploy $site && exit ; bash"
		# List the sites again
#		nl sites.txt
#		echo -n "Would you like to open another? Press X to finish "
#		read num

#	done

	# Set the start
count=1

# Get the number of lines in the file
while read -r line; do linecount=$((linecount +1)); done < sites.txt

# Make the Magic Happen!
while [[ $count != $linecount ]]
do
	site=$(sed -n "$count"p sites.txt)
	echo $(sed -n "$count"p sites.txt)
	#ssh -t bmoore_@$account.wpengine.com "sudo /nas/wp/admin deploy $site && exit ; bash"
	count=$[count +1]
	#sleep 1
done
count=$linecount
echo $(sed -n "$count"p sites.txt)