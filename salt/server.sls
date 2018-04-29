/home/teamspeak/deployteamspeak.sh:
  file.managed:
    - source: salt://scripts/deployteamspeak.sh

runscript:
  cmd.run:
    - name: home/xubuntu/deployteamspeak.sh
    
