/home/teamspeak/deployteamspeak.sh:
  file.managed:
    - source: salt://scripts/deployteamspeak.sh

./deployteamspeak.sh:
  cmd.run
    
