# Backup-Shell-Script
A Shell-Script for Backing up your selected files into a chosen Drive directory

This project has been discontinued since gdrive doesn't receive any more updates.

## gdrive required
gdrive is a command line utility for interacting with Google Drive.

It should be placed at /usr/bin/.

You can check how to install it at https://github.com/prasmussen/gdrive

## .env file
You should fill a .env file - *located at the same directory as the backup script*.

An example of a .env file is (all variables are required for the script to work):

```
USER=FontouraAbreu
DRIVEFILE="1VHSDGJASe31RQP_ew_tmJlFQ3"
BKPDIRS=(/home/${USER}/.ssh/ /home/${USER}/backupDir/)
BKPPATH=(/var/backups/)

```
