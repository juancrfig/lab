#!/bin/bash
# Build-time fabrication of the vetusto-prod-03 evidence chain. Runs as root
# inside the Dockerfile. Ends with asserts: the build FAILS if any piece of
# the fabrication doesn't hold up.
set -euo pipefail

echo 'root:hunter2' | chpasswd

groupadd developers
groupadd ops
useradd -m -s /bin/bash -G developers,ops dev
useradd -m -s /bin/bash contractor
useradd -m -s /bin/bash marta

# Contractor's history: routine work, then the two lies fall apart.
cat > /home/contractor/.bash_history <<'EOF'
cd /srv/app
ls -la
tail -n 50 logs/app.log
df -h
vi deploy.sh
./deploy.sh
top
su -
nmap -sn 10.0.0.0/24
exit
logout
EOF
chown contractor:contractor /home/contractor/.bash_history
chmod 600 /home/contractor/.bash_history
# Reading contractor's (and root's) history REQUIRES su — deliberate.
chmod 700 /home/contractor

# Root's history: the install, and a cover-up that only proved the point.
cat > /root/.bash_history <<'EOF'
apt-get update
apt-get install -y nmap
history -c
EOF
chmod 600 /root/.bash_history
chmod 700 /root

echo 'export DEPLOY_ENV=prod-eu-1' > /etc/profile.d/deploy-env.sh

# Fabricated login records: root logged in Jul 10 (claim a refuted),
# marta "currently" on pts/0 (who/w show her).
perl /tmp/build/mkutmp.pl wtmp > /var/log/wtmp
perl /tmp/build/mkutmp.pl utmp > /var/run/utmp
chmod 644 /var/log/wtmp /var/run/utmp

install -o dev -g dev -m 644 /tmp/build/brief.md      /home/dev/brief.md
install -o dev -g dev -m 644 /tmp/build/report.md     /home/dev/report.md
install -o dev -g dev -m 644 /tmp/build/cheatsheet.md /home/dev/cheatsheet.md

# ---- Build-time asserts: fail loudly if the fabrication is broken ----
last -f /var/log/wtmp root | grep -q root
# Bare who, not `who /var/run/utmp`: only the bare form applies the
# live-ut_pid filter that once broke this scenario.
who | grep -q marta
command -v nmap > /dev/null
! command -v docker > /dev/null
man -w last id env su > /dev/null   # stretch-command docs must exist
