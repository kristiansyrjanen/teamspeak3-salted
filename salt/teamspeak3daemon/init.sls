gettarextracttar:
  archive.extracted:
    - name: /opt/teamspeak
    - source: http://dl.4players.de/ts/releases/3.0.13.6/teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
    - options: jxvf
    - user: teamspeak
    - group: teamspeak
    - archive_format: tar

/etc/init.d/teamspeak:
  file.symlink:
    - target: /opt/teamspeak/ts3server_startscript.sh
    
teamspeakserver:
  service.running:
    - name: teamspeak
    - enable: True
    - sig: teamspeak
