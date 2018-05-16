gettarextracttar:
  archive.extracted:
    - name: /opt/teamspeak
    - source: http://dl.4players.de/ts/releases/3.0.13.6/teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
    - skip_verify: True
    - options: jxvf
    - user: teamspeak
    - group: teamspeak
    - archive_format: tar


startscript.sh:
  file.managed:
    - source: salt://teamspeak3daemon/ts3server_startscript.sh
    - name: /opt/teamspeak/teamspeak3-server_linux_amd64/ts3server_startscript.sh
    - user: teamspeak
    - group: teamspeak
    - mode: '0755'

/etc/systemd/system/teamspeak:
  file.symlink:
    - target: /opt/teamspeak/teamspeak3-server_linux_amd64/ts3server_startscript.sh
    - mode: '0755'

teamspeakserver:
  service.running:
    - name: teamspeak
    - watch: 
      - file: /opt/teamspeak/teamspeak3-server_linux_amd64/ts3server_startscript.sh
    - enable: True
    
