#!/bin/bash
# Script hacked up by Sean Shuping for MAAS enrollment
# references:
# https://maas.io/docs/commissioning-and-hardware-testing-scripts#heading--metadata-fields
# https://phoenixnap.com/kb/how-to-set-up-hardware-raid-megacli
# http://erikimh.com/megacli-cheatsheet/
# Download and install LSI MegaRAID Megacli
# Install alien, unzip and libncurses5 to convert rpm package to deb
#
# --- Start MAAS 1.0 script metadata ---
# name: 00-b-User-MegaRAID_single_RAID0.sh
# title: User script - MegaRAID Single RAID 0 
# description: This script creates RAID 0 volume on all physical disks on MegaRAID controller
# destructive: true
# script_type: commissioning 
# --- End MAAS 1.0 script metadata ---

if lspci | grep -q MegaRAID
then 
echo "MegaRAID Controller found will continue configuration"
 if [ -f  /opt/MegaRAID/MegaCli/MegaCli64 ] ; then
         echo "MegaCli appears to have already been downloaded and installed" 
 else
         echo "Will download and install MegaCli"
         sudo apt update
         sudo apt -y install alien unzip libncurses5
         wget https://github.com/dvntstph/devzero-misc/raw/master/MAAS/LSiMegaRaid/8-07-14_MegaCLI.zip
         unzip *Mega*.zip
         sudo alien -k --scripts Linux/MegaCli-8.07.14-1.noarch.rpm
         sudo dpkg -i *megacli*.deb
 fi
 if sudo /opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LAll -a0 | grep -q "No Virtual Drive Configured"
 then 
 echo "Will continue to create Volumes"
	 DEVICEID=$(sudo /opt/MegaRAID/MegaCli/MegaCli64 -EncInfo -aALL | grep "Device ID" | awk -F: '{print $2}')
	 for SLOTNUMBER in $(sudo /opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL  | grep "Slot Number" | awk -F: '{print $2}')
	 do 
	 sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgLdAdd -r0 [$DEVICEID:$SLOTNUMBER] -a0 
	 done
 else
 echo " At least one Volume Found, Skipping"
 fi
else 
echo " ________________________________________ "
echo "/ Noooo MegaRAID Controller found,       \ "
echo "\ nothing to see here, mooove along...   / "
echo " ---------------------------------------- "
echo "        \   ^__^                          "
echo "         \  (oo)\_______                  "
echo "            (__)\       )\/\              "
echo "                ||----w |                 "
echo "                ||     ||                 "
exit
fi