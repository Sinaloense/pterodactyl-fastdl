#!/bin/bash

### Config ###
# Web Directory of Fast Download
dirWeb="/var/www/pterodactyl-fastdl/"
# If true date format be (Month/Day/Year), if false (Day/Month/Year)
bDateFormatUSA=false
# Seconds before a next sync
secondsNextSync=20

### sync function ###
syncFastDl()
{
    # Create file to know if rsync is running
    touch /etc/pterodactyl/.rsync-running

    # Clone files from all games servers
    mkdir -p $dirWeb
    echo "---syncFastDl---"
    rsync -av --no-owner --no-group --include="*/" --include-from=/etc/pterodactyl/fastdl-include.cfg --exclude="*" --prune-empty-dirs --delete-excluded /var/lib/pterodactyl/volumes/ $dirWeb | sed '0,/^$/d'

    # Date format USA
    if [ $bDateFormatUSA = true ]; then
        date=$(date +"%m/%d/%Y %I:%M:%S %p")
    else
        date=$(date +"%d/%m/%Y %I:%M:%S %p")
    fi

    # Create/Reeplace index.html with last sync update
    echo "<div style=\"height: 100vh; display: flex; justify-content: center; align-items: center; text-align: center; color: #636b6f; font-size: 18;\">
            FastDownload
            <br>
            Last sync: $date
        </div>" > $dirWeb/index.html

    # Set public permissions
    chmod -R 755 $dirWeb
    
    # Delete file to know if rsync is running
    rm -f /etc/pterodactyl/.rsync-running
}

# Delete file to know if rsync is running
rm -f /etc/pterodactyl/.rsync-running

while :
do
    # If not exist rsync file .rsync-running
    if [ ! -f '/etc/pterodactyl/.rsync-running' ]; then
        # Sync files
        syncFastDl
    else
        echo "Sync already running..."
    fi
    
    sleep $secondsNextSync
done

# Another method of sync with inotifywait

### Sync files when start service ###
# Delete file to know if rsync is running
#rm -f /etc/pterodactyl/.rsync-running

# Sync files
#syncFastDl

### Listener of events when a file is edited, deleted, moved ###
#inotifywait -r -m -e close_write,delete,move /var/lib/pterodactyl/volumes/ | while read path action file; do
#    echo "Change detected date $(date) in ${path} action ${action} in file ${file}";
#
#    # If not exist rsync file .rsync-running
#    if [ ! -f '/etc/pterodactyl/.rsync-running' ]; then
#        # Sync files
#        syncFastDl;
#    else
#        echo "Sync already running...";
#    fi
#done