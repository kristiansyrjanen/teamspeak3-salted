#!/bin/bash
#Created by Kristian Syrjänen 2018.
#Final assignment on our Server Management course by Tero Karvinen.

NAME="$(ps -o user= -p $$ | awk '{print $1}')"

echo -e "\nInitializing Teamspeak 3 Server deployment... \n" 

#        apt-get update && upgrade

        
echo -e "\nFetching and extracting Teamspeak 3 Server tarball... \n" 

        wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
        tar -jxvf teamspeak3-server_linux_amd*.tar.bz2
        
echo -e "\nMoving files around and changing ownership... \n" 

        sudo mv teamspeak3-server_linux_amd64 /usr/local/$NAME
        sudo chown -R $NAME:$NAME /usr/local/$NAME

echo -e "\nConnecting ts3server_startscript.sh with /etc/init.d/teamspeak... \n"

        sudo n -s /usr/local/$NAME/ts3server_startscript.sh /etc/init.d/teamspeak
        
echo -e "\nConfiguring Teamspeak to automatically run after bootup... \n"
        
        sudo update-rc.d teamspeak defaults

echo -e "\nStarting up service... \n" 

        /usr/local/$NAME/ts3server_startscript.sh start
        ^C

echo -e "\nGet your privilege key with: cat /usr/local/"$NAME"/logs/ts3server_* \n" 
echo -e "\nSearch for the token line... \n"
