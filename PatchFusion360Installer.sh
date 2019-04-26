#!/bin/bash
# This script downloads the Fusion360 Installer and patches it to be able to install it with wine
# Armin Schlegel <armin.schlegel@gmx.de>, 06.03.2019


if [ "$1" ]
then
    TEMP_PATH=$(pwd)"/"
    TEMP_PATH+=$1
fi
TEMP_PATH+="/tmp/fusion360/"

mkdir -p "$TEMP_PATH" | true
cd "$TEMP_PATH"
TEMP=$(mktemp -d -p "$TEMP_PATH")
TEMP_PYTHON=$(mktemp -d -p "$TEMP_PATH")
chmod -R 755 "$TEMP_PYTHON"
chmod -R 755 "$TEMP"

if [ -z "$(which uncompyle6)" ]
then
    echo Cannot find uncompyle6
    echo You may install it with:
    echo cd /opt/
    echo wget https://files.pythonhosted.org/packages/67/32/18a25efd215b91cc0247732ed82131f84a9b0b033d9ad6c8f6d861a7e82c/uncompyle6-3.2.5.tar.gz
    echo tar xvfz uncompyle6-3.2.5.tar.gz
    echo cd uncompyle6-3.2.5
    echo pip install -e .
    echo python setup.py install
    echo 'export PATH="$PATH:/opt/uncompyle6-3.2.5/bin"'
    exit 1
fi

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
7z x "Fusion 360 Client Downloader.exe" > /dev/null 2>&1

# extracting python35.zip to gain access to platform.pyc
cd $TEMP_PYTHON
unzip $TEMP/python35.zip > /dev/null 2>&1

cd $TEMP_PYTHON
uncompyle6 platform.pyc > $TEMP/platform.py

# patching platform.py
cd $TEMP
sed -i '/maj, min, build = /c\    maj, min, build = winver[:3]' platform.py
sed -i "/return uname().system/c\    return 'Windows'" platform.py
sed -i "/return uname().release/c\    return '7'" platform.py
sed -i "/return uname().version/c\    return '6.1.7601'" platform.py

# cleanup
rm -rf $PYTHON_TEMP

# finished
echo $TEMP
