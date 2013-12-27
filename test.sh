#!/bin/bash -x

#Description: Shows total account size for a parent and children.
#Usage: l2 acct-size <acct_name>
#function acct_size {
#acct=${one}
#ssh -tq bmoore_@${acct}.wpengine.com "sudo -v && sudo /nas/wp/ec2/cluster parent-child ${acct} > /home/bmoore_/size.txt && sudo du -s /nas/wp/www/sites/${acct} >> /home/bmoore_/size.txt && sudo du -s /var/lib/mysql/wp_${acct} >> /home/bmoore_/size.txt && exit ; bash"
#scp -q bmoore_@${acct}.wpengine.com:/home/bmoore_/size.txt size.txt
#ssh -tq bmoore_@${acct}.wpengine.com "sudo du -s /nas/wp/www/sites/${acct}| sudo awk '{printf \"%.2f\",\$1/1024}') >> size.txt && sudo du -s /var/lib/mysql/wp_${acct}| sudo awk '{printf \"%.2f\",\$1/1024}') >> size.txt && exit ; bash"
#dbb="$(sudo du -s /var/lib/mysql/wp_${REPLY}| sudo awk '{printf "%.2f",$1/1024}')"
#installb=$(sed 2p size.txt| awk '{printf "%.2f",$1/1024}')
#dbb=$(sed 3p size.txt| sudo awk '{printf "%.2f",$1/1024}')
#total="$(echo ${installb}+${dbb}| bc)"
#echo -e $(cat size.txt| sed 's/ /\\n/g')| while read; do
#echo -e "Total Size: ${total}M Parent: ${acct} Child: ${REPLY} Install: ${installb}M DB: ${dbb}M\n"
#done 2>&1| sed '/^$/d'| sort -rnk3
#}
#one=$1
#two=$2
#acct_size

function acct_size {
acct=${one}
ssh -tq bmoore_@${acct}.wpengine.com "sudo -v && sudo /nas/wp/ec2/cluster parent-child ${acct} > /home/bmoore_/size.txt && exit ; bash"
scp -q bmoore_@${acct}.wpengine.com:/home/bmoore_/size.txt size.txt
echo -e  $(cat size.txt| sed 's/ /\\n/g')| while read; do 
installb=$(ssh -t bmoore_@${acct}.wpengine.com "[[ -d /nas/wp/www/sites/${REPLY} ]] && sudo du -s /nas/wp/www/sites/${REPLY} | awk '{printf \"%.2f\",\$1/1024}' > /home/bmoore_/install-size.txt && exit ; bash" && scp bmoore_@${acct}.wpengine.com:/home/bmoore_/install-size.txt install-size.txt && cat install-size.txt)
dbb=$(ssh -t bmoore_@${acct}.wpengine.com "[[ -d /nas/wp/www/sites/${REPLY} ]] && sudo du -s /var/lib/mysql/wp_${REPLY} | awk '{printf \"%.2f\",\$1/1024}' > /home/bmoore_/db-size.txt && exit ; bash" && scp bmoore_@${acct}.wpengine.com:/home/bmoore_/db-size.txt db-size.txt && cat db-size.txt)
total=$(echo ${installb}+${dbb}) # | bc)
#$(du -s /nas/wp/www/sites/${REPLY} | awk '{printf \"%.2f\",\$1/1024}') && dbb=$(sudo du -s /var/lib/mysql/wp_${REPLY} | awk '{printf \"%.2f\",\$1/1024}') && total=$(echo \${installb}+\${dbb} | bc) && 
echo -e "Total Size: ${total}M Parent: ${acct} Child: ${REPLY} Install: ${installb}M DB: ${dbb}M\n"
done 2>&1| sed '/^$/d'| sort -rnk3 
ssh -tq bmoore_@${acct}.wpengine.com "sudo rm size.txt install-size.txt db-size.txt && exit ; bash" && rm size.txt install-size.txt db-size.txt
}
one=$1
two=$2
acct_size


#acct_size() { [[ -z "$*" ]] && echo -e "\n\nDescription: Shows total account size for a parent and children.\nUsage: acct_size <acct_name>\n\n" && return 0 || sudo -v; acct=${1}; echo -e $(sudo /nas/wp/ec2/cluster parent-child ${acct}| sed 's/ /\\n/g')| while read; do [[ -d /nas/wp/www/sites/${REPLY} ]] && installb=$(du -s /nas/wp/www/sites/${REPLY}| awk '{printf "%.2f",$1/1024}') && dbb=$(sudo du -s /var/lib/mysql/wp_${REPLY}| awk '{printf "%.2f",$1/1024}') && total=$(echo ${installb}+${dbb}| bc) && echo -e "Total Size: ${total}M Parent: ${acct} Child: ${REPLY} Install: ${installb}M DB: ${dbb}M\n"; done 2>&1| sed '/^$/d'| sort -rnk3; }; acct_size