# BashDASDEC
A software DASDEC written entirely in bash. Can decode NERP IPAWS CAP and FEMA IPAWS CAP (With some modification)


Requirements:
Screen
FFMpeg
FLite
MiniModem
APlay (Part of ALSA) (Can be swapped for any other media player)

Install:
```
git clone https://github.com/libmarleu/BashENDEC.git
cd BashDASDEC
sh install.sh
```

Usage:

```
screen standby.sh
```

This will monitor the CAP feed and forward new alerts.

The software might relay an alert at first boot because it needs to cache the previous alert.

***I TAKE NO RESPONSIBILITY FOR ANY MISUSE OR ACCIDENTAL ACTIVATION OF THE EXTERNAL EMERGENCY ALERT SYSTEM!***
