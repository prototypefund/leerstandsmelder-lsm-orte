#!/bin/bash

unset BUNDLE_PATH
unset BUNDLE_BIN

set -e

cat >/etc/motd <<EOL
    ___       ___       ___            ___       ___       ___       ___   
   /\__\     /\  \     /\__\          /\  \     /\  \     /\  \     /\  \  
  /:/  /    /::\  \   /::L_L_        /::\  \   /::\  \    \:\  \   /::\  \ 
 /:/__/    /\:\:\__\ /:/L:\__\      /:/\:\__\ /::\:\__\   /::\__\ /::\:\__\
 \:\  \    \:\:\/__/ \/_/:/  /      \:\/:/  / \;:::/  /  /:/\/__/ \:\:\/  /
  \:\__\    \::/  /    /:/  /        \::/  /   |:\/__/   \/__/     \:\/  / 
   \/__/     \/__/     \/__/          \/__/     \|__|               \/__/  
   
   
   LSM-ORTE

EOL
cat /etc/motd

# whenever has to be run from the main app folder.
# it will look for schedule.rb in /opt/app/config folder
cd /opt/app
# whenever --update-crontab
# restart cron after updating crontab
# service cron restart
# for logging
# crontab -l

#bundle exec rails assets:precompile
#yarn install

#rails s
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
