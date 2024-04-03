#!/bin/bash

# the IP of the servers are in inventory.txt (you need to creat)
servers=$(cat inventory.txt)

# read the username and userid
echo -n "Enter the user name:"
read username
echo -n "Enter the user id:"
read userid

# loop through all the servers, and add the new user to each server
for i in $servers; do
	echo $i # display the name of the current server of the list
	ssh  $i "sudo useradd -m -u $userid $username" # access the server and add the user
	# error checking
	if [ $? -eq 0 ]; then
		echo "User $username is add sucessfully on $i"
	else
		echo "Error on $i"
	fi
done
