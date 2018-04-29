#!/bin/bash
#Created by Kristian Syrjänen 2018.
#Final assignment on our Server Management course by Tero Karvinen.

CYAN='\033[0;36m'
NC='\033[0m'


echo -e "\n${CYAN}Initializing Teamspeak 3 Server deployment... \n" ${NC}

        apt-get update && upgrade

        
echo -e "\n${CYAN}Fetching and extracting Teamspeak 3 Server tarball... \n" ${NC}

        wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
        tar -jxvf teamspeak3-server_linux_amd*.tar.bz2
        
echo -e "\n${CYAN}Moving files around and changing ownership... \n" ${NC}

        sudo mv teamspeak3-server_linux_amd64 /usr/local/xubuntu
        sudo chown -R xubuntu:xubuntu /usr/local/xubuntu

echo -e "\n${CYAN}Connecting ts3server_startscript.sh with /etc/init.d/teamspeak... \n" ${NC}

        sudo n -s /usr/local/teamspeak/ts3server_startscript.sh /etc/init.d/teamspeak
        
echo -e "\n${CYAN}Configuring Teamspeak to automatically run after bootup... \n" ${NC}
        
        sudo update-rc.d teamspeak defaults

echo -e "\n${CYAN}Starting up service... \n" ${NC}

        sudo service teamspeak start

echo -e "\n${CYAN}Get your privilege key with: cat /usr/local/xubuntu/logs/ts3server_* \n" ${NC}
echo -e "\n${CYAN}Search for the token line... \n" ${NC}
