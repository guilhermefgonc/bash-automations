#!/bin/bash

filesys=("/" "/apps" "database") # filesystem to check

# loop through each filesystem
for i in ${filesys[@]}; do
	# get disk usage percentage of the filesystem, already formatted
	usage=$(df -h $i | tail -n 1 | awk '{print $5}' | cut -d % -f1)
	# check if disk space usage is greater or equal to 80
	if [ $usage -ge 80 ]; then
		alert="Running out of space in $i, usage is $usage%" # alert message
		echo "Sending out a disk space alert email"
		echo $alert | mail -s "$i is usage $usage% full" email@email.com # send an email alert to the specified email
	fi
done
