# 

# Teamspeak 3 Daemon, Salted
Salt state that will install a Teamspeak 3 daemon. Works with Xubuntu machines. 

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

### Top.sls structure

Create the **top.sls** so that it will highstate all machines with "teamspeak" in its name, eg. *teamspeak99*, *teamspeakKube* and so on.

    base:
      'teamspeak*':
        - user:
        - firewall
        - teamspeak3daemon

After this all Salt-Minions connected to the Salt-Master with the name *teamspeak-xxxx* will create a Teamspeak 3 daemon.

### References

[SaltStack Docs for motivational loss](https://docs.saltstack.com/en/latest/)

[TeroKarvinen.com in general and course page](http://terokarvinen.com/2018/aikataulu-%E2%80%93-palvelinten-hallinta-ict4tn022-4-ti-5-ke-5-loppukevat-2018-5p)

[Jori Laine, Arctic CCM Project](https://github.com/joonaleppalahti/CCM/tree/master/salt/srv/salt)

[Xubuntu.org for the ISO-file](https://xubuntu.org/release/18-04/)

[Rufus for creating the LIVE-USB](https://rufus.akeo.ie/)

[My personal website/portfolio](https://ksyrjanen.me)
