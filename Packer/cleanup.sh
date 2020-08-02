#!/bin/bash

# cleanup all old logs
rm -rf /var/log/messages-*
echo > /var/log/messages
rm -rf /var/log/secure
rm -rf /var/log/lastlog
rm -rf /var/lib/cloud/instances/*
rm -rf /tmp/*log
rm -rf /root/.histor*
