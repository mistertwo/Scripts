#/bin/bash -x

# Get the Account name when needed
	echo -n "What is the account name we will be working with? "
	read account

# Get the list of sites
ssh -t bmoore_@$account.wpengine.com "cd /nas/wp/www/sites && ls > /home/bmoore_/sites.txt && exit ; bash"

# Get that list and then nl locally.
scp -r bmoore_@$account.wpengine.com:/home/bmoore_/sites.txt sites.txt
# && nl sites.txt

# Parse that list, and apply a Deploy to the selected Site. I'm doing this manually instead of Automatically in order to keep from killing the server.
#echo -n "Which Site would you like to \"Deploy\"? Pick a number. "
#		read num
# Set the start
count=1

# Get the number of lines in the file
while read -r line; do linecount=$((linecount +1)); done < sites.txt

# Make the Magic Happen!
while [[ $count != $linecount ]]
do
	site=$(sed -n "$count"p sites.txt)
	#echo $(sed -n "$count"p sites.txt)
	ssh -t bmoore_@$account.wpengine.com "sudo /nas/wp/admin deploy $site && exit ; bash"
	count=$[count +1]
	#sleep 1
done
count=$linecount
site=$(sed -n "$count"p sites.txt)
ssh -t bmoore_@$account.wpengine.com "sudo /nas/wp/admin deploy $site && exit ; bash"