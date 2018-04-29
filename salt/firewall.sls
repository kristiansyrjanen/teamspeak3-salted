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
