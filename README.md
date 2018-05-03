# teamspeak3-salted
Salt state that will install a Teamspeak 3 daemon on a Xubuntu 16.04 Live-USB instance. 

## Getting started
Done on a Lenovo Ideapad 700 with Xubuntu 16.0.4 LTS live-USB.

First I updated my packages.
  
    sudo apt-get update

### Installing and configuring salt-master and salt-minion

I install the salt-master daemon and salt-minion daemon.

    sudo apt-get -y install salt-master salt-minion

After I installed salt-master and salt-minion I configured the /etc/salt/minion and /etc/salt/master files.

    sudoedit /etc/salt/minion
    ~$
    master: [IP-address]
    id: teamspeak

Then the master file to get rid of the file_ignore_glob error message.

    sudoedit /etc/salt/master
    ~$
    file_ignore_glob: []

After I edited the files I needed to restart the salt-master and salt-minion daemons.

    sudo systemctl restart salt-master.service
    sudo systemctl restart salt-minion.service

Accepted the salt-minion key.

    sudo salt-key
    sudo salt-key -a teamspeak

Tested that the minion responds by using test.ping.

    sudo salt 'teamspeak' test.ping
  
It returned with the value "True" which means it works.

### Creating the state (.sls) files and scripts

I started by creating the *top.sls* file
