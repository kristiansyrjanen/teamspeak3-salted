#!/bin/bash


CYAN='\033[0;36m'
NC='\033[0m'


echo -e "\n${CYAN}Initializing Teamspeak 3 Server deployment... \n" ${NC}

        apt-get update && upgrade

        
echo -e "\n${CYAN}Fetching and extracting Teamspeak 3 Server tarball... \n" ${NC}

        wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
        tar -jxvf teamspeak3-server_linux_amd*.tar.bz2
        
echo -e "\n${CYAN}Moving files around and changing ownership... \n" ${NC}

        mv teamspeak3-server_linux_amd64 /usr/local/teamspeak
        chown -R teamspeak:teamspeak /usr/local/teamspeak

echo -e "\n${CYAN}Connecting ts3server_startscript.sh with /etc/init.d/teamspeak... \n" ${NC}

        ln -s /usr/local/teamspeak/ts3server_startscript.sh /etc/init.d/teamspeak
        
echo -e "\n${CYAN}Get your privilege key with: cat /usr/local/teamspeak/logs/ts3server_* \n" ${NC}
echo -e "\n${CYAN}Search for the token line... \n" ${NC}
