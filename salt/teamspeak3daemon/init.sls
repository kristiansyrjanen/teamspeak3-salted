# Made by Kristian Syrjänen, 2018.

gettarextracttar:
  archive.extracted:
    - name: /opt/teamspeak
    - source: http://dl.4players.de/ts/releases/3.0.13.6/teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
    - skip_verify: True
    - options: jxvf
    - user: teamspeak
    - group: teamspeak
    - archive_format: tar

/etc/init.d/teamspeak:
  file.symlink:
    - target: /opt/teamspeak/teamspeak3-server_linux_amd64/ts3server_startscript.sh
 
# macgyvered version that works but wont end the state
# 16.5.2018 Kristian Syrjänen

service.start:
  cmd.run:
    - name: /etc/init.d/teamspeak start


#notworking 16.5.2018 Kristian Syrjänen
#The named service teamspeak is not available.

#teamspeakserver:
#  service.running:
#    - name: teamspeak
#    - enable: True
#    - sig: teamspeak
