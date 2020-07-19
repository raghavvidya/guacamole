#!/bin/bash

# cleanup all old logs
sudo rm -rf /var/log/log
sudo rm -rf /var/log/secure
sudo rm -rf /var/log/lastlog
sudo rm -rf /var/lib/cloud/instances/*
sudo rm -rf /tmp/*log