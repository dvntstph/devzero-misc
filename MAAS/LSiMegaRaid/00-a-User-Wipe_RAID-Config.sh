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
# name: 00-a-User-Wipe_RAID-Config.sh
# title: User script - Wipe MegaRAID 
# description: This script clears all configuration from MegaRAID controllers 
# destructive: true
# script_type: commissioning 
# --- End MAAS 1.0 script metadata ---

if lspci | grep -q MegaRAID
then 
echo "MegaRAID Controller found will wipe existing configuration"
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
sudo /opt/MegaRAID/MegaCli/MegaCli64 -CacheCade -remove -LALL -aALL
sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgCacheCadeDel -LALL -aALL
sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgLdDel -LAll -aAll
sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgClr -force -aAll
else 
echo " ________________________________________ "
echo "/ Noooo MegaRAID Controller found,       \ "
echo "\ nothing to see here, moooove along...  / "
echo " ---------------------------------------- "
echo "        \   ^__^                          "
echo "         \  (oo)\_______                  "
echo "            (__)\       )\/\              "
echo "                ||----w |                 "
echo "                ||     ||                 "
exit
fi