#! /bin/bash
# quakeinstall-qlserver.sh - quake live dedicated server installation for qlserver user.
# intended to be run on a fresh VPS/Dedicated Server, this script must be run under the qlserver user.
# created by Thomas Jones on 29/09/15.

if [ "$(whoami)" -ne "qlserver" ]
  then echo "Please run under user 'qlserver'."
  exit
fi
clear
cd ~/
git clone https://github.com/dark-saber/QuakeLiveDS_Scripts
echo "Installing SteamCMD..."
mkdir ~/steamcmd; cd ~/steamcmd; wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; tar -xvzf steamcmd_linux.tar.gz; rm steamcmd_linux.tar.gz
clear
echo "Installing Quake Live Dedicated Server..."
./steamcmd.sh +login anonymous +force_install_dir /home/qlserver/steamcmd/steamapps/common/qlds/ +app_update 349090 +quit
clear
echo "Cronning 'QuakeUpdate.sh'..."
echo "0 8 * * * /home/qlserver/quakeupdate.sh" > cron; crontab cron; rm cron
clear
chmod +x /home/qlserver/QuakeLiveDS_Scripts/scripts/*.sh
ln -s /home/qlserver/QuakeLiveDS_Scripts/scripts/*.sh /home/qlserver
echo "Now execute minqlx.sh and extraplugins.sh, then cd ~; ./quakeconfig.sh; ./quakeupdate.sh"
exit
