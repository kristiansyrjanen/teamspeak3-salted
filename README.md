# teamspeak3-salted
Salt state that will install a Teamspeak 3 daemon on a Xubuntu 18.04 LTS Live-USB instance. 

## Getting started
Done on a Lenovo Ideapad 700 with Xubuntu 16.0.4 LTS live-USB, tested also with Xubuntu and Kubuntu 18.04 LTS Live-USB.

First I updated my packages.
  
    sudo apt-get update

### Installing and configuring salt-master and salt-minion

I install the **salt-master** daemon and **salt-minion** daemon.

    sudo apt-get -y install salt-master salt-minion

After I installed **salt-master** and **salt-minion** I configured the **/etc/salt/minion** and **/etc/salt/master** files.

    sudoedit /etc/salt/minion
    ~$
    master: [IP-address]
    id: teamspeak

Then the master file to get rid of the *file_ignore_glob* error message.

    sudoedit /etc/salt/master
    ~$
    file_ignore_glob: []

After I edited the files I needed to restart the **salt-master** and **salt-minion** daemons.

    sudo systemctl restart salt-master.service
    sudo systemctl restart salt-minion.service

Accepted the salt-minion key.

    sudo salt-key
    sudo salt-key -a teamspeak

Tested that the minion responds by using **test.ping**.

    sudo salt 'teamspeak' test.ping
  
It returned with the value "True" which means it works.

### Creating the state (.sls) files and scripts

I started by creating the **top.sls** file. I create the files in **/srv/salt/**.

    base:
      'teamspeak':
        - firewall
        - server

### Creating the firewall state

I created a **firewall.sls** state file. The firewall state needs **user.rules** and **user6.rules** which will be managed straight from the master, **/srv/salt/firewall/**. It also needs to be enabled.

    ufw:
      pkg.installed

    /etc/ufw/user.rules:
      file:
        - managed
        - source: salt://firewall/user.rules
        - require:
          - pkg: ufw

    /etc/ufw/user6.rules:
      file:
        - managed
        - source: salt://firewall/user6.rules
        - require:
          - pkg: ufw

    ufw-enable:
       cmd.run:
         - name: 'ufw --force enable'
         - require:
    - pkg: ufw
    
Teamspeak 3 daemon needs 3 ports open: **9987/udp**, **10011/tcp** and **3033/tcp**. These will be in the **user.rules** and **user6.rules** files.

[The important lines on the user.rules file.](https://github.com/kristiansyrjanen/teamspeak3-salted/blob/master/salt/firewall/user.rules)
    

    ### tuple ### allow tcp 22 0.0.0.0/0 any 0.0.0.0/0 in
    -A ufw-user-input -p tcp --dport 22 -j ACCEPT

    ### tuple ### allow udp 9987 0.0.0.0/0 any 0.0.0.0/0 in
    -A ufw-user-input -p udp --dport 9987 -j ACCEPT

    ### tuple ### allow tcp 10011 0.0.0.0/0 any 0.0.0.0/0 in
    -A ufw-user-input -p tcp --dport 10011 -j ACCEPT

    ### tuple ### allow tcp 3033 0.0.0.0/0 any 0.0.0.0/0 in
    -A ufw-user-input -p tcp --dport 3033 -j ACCEPT

    
    
[And the important lines on the user6.rules file.](https://github.com/kristiansyrjanen/teamspeak3-salted/blob/master/salt/firewall/user6.rules)
    
    ### tuple ### allow tcp 22 ::/0 any ::/0 in
    -A ufw6-user-input -p tcp --dport 22 -j ACCEPT

    ### tuple ### allow udp 9987 ::/0 any ::/0 in
    -A ufw6-user-input -p tcp --dport 9987 -j ACCEPT

    ### tuple ### allow tcp 10011 ::/0 any ::/0 in
    -A ufw6-user-input -p tcp --dport 10011 -j ACCEPT

    ### tuple ### allow tcp 3033 ::/0 any ::/0 in
    -A ufw6-user-input -p tcp --dport 3033 -j ACCEPT
    
### Creating the server state (.sls) and the installation bash-script

To run a command in a state you usually use cmd.run but for scripts there is a different salt.module for it, which is called **cmd.script**. I will create a **server.sls** file that runs my installation bash-script.

    runscript:
      cmd.script:
        - source: salt://scripts/deployteamspeak.sh

The bash-script will fetch the Teamspeak 3 daemon tarball, extracts it, moves it and more.


    echo -e "\nInitializing Teamspeak 3 Server deployment... \n" 

            apt-get update


    echo -e "\nFetching and extracting Teamspeak 3 Server tarball... \n" 

            wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
            tar -jxvf teamspeak3-server_linux_amd*.tar.bz2

    echo -e "\nMoving files around and changing ownership... \n" 

            sudo mv teamspeak3-server_linux_amd64 /usr/local/xubuntu
            sudo chown -R xubuntu:xubuntu /usr/local/xubuntu

    echo -e "\nConnecting ts3server_startscript.sh with /etc/init.d/teamspeak... \n"

            sudo ln -s /usr/local/teamspeak/ts3server_startscript.sh /etc/init.d/teamspeak

    echo -e "\nConfiguring Teamspeak to automatically run after bootup... \n"

            sudo update-rc.d teamspeak defaults

    echo -e "\nStarting up service... \n" 

            sudo systemctl start teamspeak

    echo -e "\nGet your privilege key with: cat /usr/local/xubuntu/logs/ts3server_* \n" 
    echo -e "\nSearch for the token line... \n"
    
*I created this bash-script so that it can be run straight from my gitrepository, not only as a state.*

### Cloning the repository and running the state

I clone the repository and move the **salt** directory under **/srv/**. NOTE: You will need **git** for this. (**install it with sudo apt-get install git**)

    git clone https://github.com/kristiansyrjanen/teamspeak3-salted.git
    cd teamspeak3-salted
    sudo mv salt/ /srv/

Now that I have all in the right places I can run my state.

    sudo salt '*' state.highstate
    
Seems like the state worked. Tried to connect with the IP address to the newly made TS3 server and I got in. This means that both the **firewall.sls** and the **server.sls** works. 

Also all of the files are in place, under **/usr/local/xubuntu/**.

# The module is ready for presentation

##### Might add more states during the weekend, eg. user creation using pillars and jinja.
