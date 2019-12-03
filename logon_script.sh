#!/usr/bin/bash
#This script will automate the back ups of specified folders and files of a user's home directory
#It is the preperation before being sent to a remote server by the server team
######################################################################
#Declaring variables
getDate=$(date +%Y-%m-%d)  #Grabs the date into a variable
getLastDate=$(date -d "last friday" +%Y-%m-%d) #grabs the date of last
previousLogFile=backups_$getLastDate.log
######################################################################

#This portion if for the zenity prompt
#This will be a separate script to check if the backup directory
#exists when the users logs in to confirm successful backup
#This script will execute with a weekly cron job and will prompt the user at logon

grep -i "successful" ~/.local/log/backup_logs/$previousLogFile

if [ $? = 0 ]
then
  zenity --info --title="Backup Successful" --width=300 --timeout=5 --text="Your files have been successfully backed up."
else
  zenity --info --title="Backup Failed" --width=300 --timeout=5 --text="Your weekly backup has failed, please contact IT Support to determine failure."
fi
