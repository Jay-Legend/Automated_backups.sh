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

######################################################################
#Parsing and copying folders and files to back up folder
mkdir $HOME/backup_"$getDate"   #to creat the backup folder with dates
backupFolder=$HOME/backup_"$getDate"
zenity --question --title="Weekly Backup" --width=300 --timeout=10 --text="Your scheduled weekly backup will occur at 6PM, would you like to postpone?"
if [ $? = 1 ]; then
cp -R $HOME/Music "$backupFolder" #to copy the music directory into the backup directory
cp -R $HOME/Documents "$backupFolder"  #copy documents into teh backup folder
cp -R $HOME/Pictures "$backupFolder"  #copy pictures to bakup
cp -R $HOME/Public "$backupFolder"  #copy public to bakup
cp -R $HOME/Templates "$backupFolder" #copy templates to backup
cp -R $HOME/.bash_history "$backupFolder" #copy bashhistory to backup
cp -R $HOME/.bash_profile "$backupFolder"
tar -czvf "$backupFolder".tar.gz "$backupFolder"
else
  zenity --info --title="Postpone Backup" --width=300 --text="Your backup will occur next week at 6PM."
fi
######################################################################
######################################################################
#Logging Portion
#Variable storing the log file name
logFileName=backups_$getDate.log #name of the log file
#The following conditional tests for a log directory, if not present
#It will be created and log file created as well.
if [ ! -d $HOME/.local/log ]
then
  mkdir $HOME/.local/log/
  mkdir $HOME/.local/log/backup_logs
  touch $HOME/.local/log/backup_logs/$logFileName
else
  touch $HOME/.local/log/backup_logs/$logFileName
fi
#The following conditional tests if the backup folder is empty
#If its empty, then a log file will be appeneded with failed otherwise successful
if [ ! "$(ls -A $backupFolder)" ]
then
    echo "backup failed" >> $HOME/.local/log/backup_logs/$logFileName
else
  ls -A -R $backupFolder  > $HOME/.local/log/backup_logs/$logFileName
  echo "backup successful" >> $HOME/.local/log/backup_logs/$logFileName
fi
######################################################################
######################################################################
#Remove the original backup folder after archiving
rm -r $backupFolder
######################################################################
