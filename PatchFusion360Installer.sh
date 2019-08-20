#!/bin/bash
# This script downloads the Fusion360 Installer and patches it to be able to install it with wine
# Armin Schlegel <armin.schlegel@gmx.de>, 20.08.2019
#
# usage: 	./PatchFusion360Installer.sh <target-directory-from-cwd> <verbose>
# example:  ./PatchFusion360Installer.sh install_files 
# example:  ./PatchFusion360Installer.sh tmp 1

scriptdir="$(dirname $(readlink -f $0))"

if [ "$1" ]
then
    TEMP_PATH=$(pwd)"/"
    TEMP_PATH+=$1
fi
TEMP_PATH+="/tmp/fusion360/"

mkdir -p $TEMP_PATH | true
cd $TEMP_PATH
TEMP=$(mktemp -d -p $TEMP_PATH)
chmod -R 755 $TEMP

if [ -z "$(which 7z)" ]
then
    echo Cannot find 7z
    echo You may install it with:
    echo sudo apt install 7z
    exit 1
fi


# downloading and extracting the installer
cd $TEMP

wget "https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Client%20Downloader.exe" > /dev/null 2>&1
if [ "$2" ]
then
	echo Extracting file Fusion 360 Client Downloader.exe
fi
7z x "Fusion 360 Client Downloader.exe" > /dev/null 2>&1

# patching platform.py
cd $TEMP
wget "https://raw.githubusercontent.com/python/cpython/master/Lib/platform.py" > /dev/null 2>&1
sed -i '/maj, min, build = /c\    maj, min, build = winver[:3]' platform.py
sed -i "/return uname().system/c\    return 'Windows'" platform.py
sed -i "/return uname().release/c\    return '7'" platform.py
sed -i "/return uname().version/c\    return '6.1.7601'" platform.py

if [ "$2" ]
then
	echo Patched lines are:
	cat platform.py | grep "maj, min, build ="
	cat platform.py | grep "return 'Windows'"
	cat platform.py | grep "return '7'"
	cat platform.py | grep "return '6.1.7601'"
fi

# finished
if [ -z "$2" ]
then
	echo $TEMP
else
	echo Please run 'wine streamer.exe' from $TEMP
fi
