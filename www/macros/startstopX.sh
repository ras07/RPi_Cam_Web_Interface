#!/bin/bash

# Run this after an RPiCamControl update to re-patch things I've changed

# First auto-update and restart
SELF=`basename "$0"`
if [ "$1" != "HasBeenUpdated" ]; then
	echo Updating "$SELF" ...
	cd ~/bin
	fetch "$SELF" ras 744 nobackup
	"$SELF" HasBeenUpdated
	exit
fi


if [ -e /var/www/birdcam/diskUsage.txt.save ]; then
	echo Restoring diskUsage.txt.save ...
	sudo cp /var/www/birdcam/diskUsage.txt.save /var/www/birdcam/diskUsage.txt
fi


echo Patching preview.php ...
sudo cp /var/www/birdcam/preview.php /var/www/birdcam/preview.php.orig

# Make the "Delete Selected" button yellow instead of red
sudo sed -i 's/'\
$'button class=\'btn btn-danger\' type=\'submit\' name=\'action\' value=\'deleteSel\'/'\
$'button class=\'btn btn-warning\' type=\'submit\' name=\'action\' value=\'deleteSel\'/' \
/var/www/birdcam/preview.php

# Make the "Delete All" NOT recursive!
sudo sed -i 's/'\
'maintainFolders(MEDIA_PATH, true, true);/'\
'maintainFolders(MEDIA_PATH, true, false);/' \
/var/www/birdcam/preview.php



if [ -e /var/www/birdcam/macros/startstopX.sh ]; then
	sudo rm -f /var/www/birdcam/macros/Xstartstop.sh
	sudo mv -f /var/www/birdcam/macros/startstopX.sh Xstartstop.sh
fi
