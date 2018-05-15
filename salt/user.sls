teamspeak:
  group:
    - present
  user.present:
    - fullname: Teamspeak3Server
    - groups:
      - teamspeak
    - shell: /bin/bash
    - home: /home/teamspeak
    - nologinit: True
    - password: "!"
    - enforce_password: True
