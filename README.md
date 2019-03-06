# winepatchfusion360installer
Contains a script that makes the Fusion 360 installer install in Linux using wine
This is based on the information from: https://appdb.winehq.org/objectManager.php?sClass=version&iId=36468&iTestingId=104527

The script downloads the installer and patches the platform.py file.
Note: This file patches only the installer. None of the application itself is being altered with. 

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

**Uage:**

Just run the script.

```
$ git clone https://github.com/siredmar/winepatchfusion360installer
$ cd winepatchfusion360installer
$ ./PatchFusion360Installer.sh
--2019-03-06 08:07:23--  https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Client%20Downloader.exe
Resolving dl.appstreaming.autodesk.com (dl.appstreaming.autodesk.com)... 23.38.41.109
Connecting to dl.appstreaming.autodesk.com (dl.appstreaming.autodesk.com)|23.38.41.109|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 11595800 (11M) [application/octet-stream]
Saving to: ‘Fusion 360 Client Downloader.exe’

Fusion 360 Client Downloader.exe     100%[=====================================================================>]  11,06M  9,67MB/s    in 1,1s    

2019-03-06 08:07:24 (9,67 MB/s) - ‘Fusion 360 Client Downloader.exe’ saved [11595800/11595800]

Extracting file Fusion 360 Client Downloader.exe
Patched lines are:
    maj, min, build = winver[:3]
    return 'Windows'
    return '7'
    return '6.1.7601'
Please run wine streamer.exe from /home/user/tmp/fusion360/tmp.CjNLGUqWQK
```

You are now able to execute the patched installer from the output directory. Note: You have to manually clean up this temporary directory.
