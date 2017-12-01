#!/usr/bin/env bash
echo "Starting bootstrap"

systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  echo "apt-daily still running"
  sleep 1;
done



