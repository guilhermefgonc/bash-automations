# Bash Automation Scripts

This repository contains 3 Bash scripts that automate some tasks. These scripts were created as part of a study about Bash scripting.

## Scripts:

1. **Automating Backups**
   - Script: `backup.sh`
   - Description: This script performs backups of specified directories and transfers them to a backup server using SCP.
   - Code:

   ```bash
    #!/bin/bash
    
    backup_dirs=("/etc" "/home" "/boot") # directories that are going to be backed up
    dest_dir="/backup" # backup destination
    dest_server="ip" # ip of the backup server
    backup_date=$(date +%b-%d-%y) # timestamp
    
    echo "Starting backup of: ${backup_dirs[@]}"
    
    # loop through all directories
    for i in "${backup_dirs[@]}"; do
    	# create a compressed tar archive of the current dir
    	# and save it with the dir name and backup timestamp in /tmp
    	sudo tar -Pczf /tmp/$i-$backup_date.tar.gz $i
    	# error checking
    	if [ $? -eq 0 ]; then
    		echo "$i Backup succeeded"
    	else
    		echo "$i Backup failed"
    	fi
    	# transfer the created backup file to the destination server using scp command
    	scp -i /caminho/para/chave/chave.pem /tmp/$i-$backup_date.tar.gz ubuntu@$dest_server:$dest_dir
    	# error checking
    	if [ $? -eq 0 ]; then
    		echo "$i Backup transfer succeeded"
    	else
    		echo "$i Backup transfer failed"
    	fi
    done
    
    # cleanup /tmp
    sudo rm /tmp/*.gz
    
    echo "Backup script is done"

2. **Disk Space Checker:**
   - Script: `monitoring_disk.sh`
   - Description: This script checks the disk space usage on specified filesystems and sends an email alert if the usage exceeds 80%.
   - Code:

   ```bash
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

3. **User Management:**
   - Script: `user_management.sh`
   - Description: This script adds a new user to a list of servers that you specify in the `inventory.txt` file.
   - Code:

   ```bash
    #!/bin/bash
    
    # the IP of the servers are in inventory.txt
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
