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
