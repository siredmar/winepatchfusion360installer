# winepatchfusion360installer
Contains a script that makes the Fusion 360 installer install in Linux using wine
This is based on the information from: https://appdb.winehq.org/objectManager.php?sClass=version&iId=36468&iTestingId=104527

The script downloads the installer and uses a correct version of platform.py for the installation process.

**Note: This file does not modify any parts of the application itself.**

**Preparations:**
Install 64 Bit Version of Wine. I tested it with Wine 4.3.

Set machine as Windows 7 or newer (tested only with Win7):
```
$ winetricks win7
```

Install vcrun2017 and then reset the Windows release, because winetricks sets it as Windows XP:
```
$ winetricks vcrun2017
$ winetricks win7
```

Disable the d3d11 library completely:
```
$ winetricks d3d11=disabled
```

**Usage:**

You can choose optional the target directory within the current working directory and make the output a little bit verbose.
`$ ./PatchFusion360Installer.sh <target-directory-from-cwd> <verbose>`

Example:
```
$ git clone https://github.com/siredmar/winepatchfusion360installer.git
$ cd winepatchfusion360installer
$ ./PatchFusion360Installer.sh install_files 1 
Extracting file Fusion 360 Client Downloader.exe
Patched lines are:
    maj, min, build = winver[:3]
    return 'Windows'
    return '7'
    return '6.1.7601'
Please run wine streamer.exe from /home/user/winepatchfusion360installer/install_files/tmp/fusion360/tmp.zguMnw00e1
```

You are now able to execute the patched installer from the output directory. Note: You have to manually clean up this temporary directory.

After starting streamer.exe with wine you may look at the installers log files to verify that installation is going on by e.g. 
```
$ tail -f ~/.wine/drive_c/users/$USER/Local\ Settings/Application\ Data/Autodesk/autodesk.webdeploy.streamer.log
```

**Notes:**
If you don't see the graphic canvas in Fusion 360 you might change Direct3D to version 9.
Fusion 360's Preferences -> General -> Graphics driver and set it to DirectX 9 explicitly (instead of the default 'Auto-select')
