#!/bin/bash
echo -n "Please enter Guacamole login user  "
read USERNAME
echo -n "Please enter Guacamole login password "
read -s PASSWORD
echo
export URL="https://$(hostname -I|tr -d ' ')/guacamole"
#get the VNC & VNC user connection template from api doc and update accordingly
export VNC_TEMPLATE="createvnc_connection.template"
export USER_CONNECTION="vnc_connection.template"
export VNC_FILE="vnc.csv"
export TOKEN=$(curl -X POST ${URL}/api/tokens -d "username=${USERNAME}&password=${PASSWORD}"  -k|jq .authToken|sed 's/"//g')

while read -r VNC_USERNAME VNC_SERVER VNC_PORT
do
   export VNC_CONNECTIONNAME="${VNC_USERNAME}-${VNC_SERVER}-${VNC_PORT}"
   sed -e "s/VNC_CONNECTIONNAME_REPLACEME/$VNC_CONNECTIONNAME/g" -e "s/VNC_USERNAME_REPLACEME/$VNC_USERNAME/g" -e "s/VNC_SERVER_REPLACEME/$VNC_SERVER/g" -e "s/VNC_PORT_REPLACEME/$VNC_PORT/g" ${VNC_TEMPLATE} > ${VNC_TEMPLATE}_process.tmp
   curl -d "@${VNC_TEMPLATE}_process.tmp" -X POST ${URL}/api/session/data/mysql/connections?token=${TOKEN} -k --header "Content-Type: application/json" > myconection.tmp
   export identifier=$(cat myconection.tmp |jq|grep identifier|awk '{print $2}'|sed -e 's/"//g' -e 's/,//g')
   sed -e "s/CONNECTIONID_REPLACEME/${identifier}/g" ${USER_CONNECTION} > ${USER_CONNECTION}_process.tmp
   curl -d "@${USER_CONNECTION}_process.tmp" -X PATCH ${URL}/api/session/data/mysql/users/${VNC_USERNAME}/permissions?token=${TOKEN} -k --header "Content-Type: application/json"
done < ${VNC_FILE}
rm -rf *tmp
