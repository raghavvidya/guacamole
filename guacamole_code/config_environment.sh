#!/bin/bash
set -x

echo "Generate the base64 string and passing to Cloudformation userdata"
tar cvfz guacamole_code/userdata.tar.gz guacamole_code/userdata.sh
export UserData=$(base64 -w 0 guacamole_code/userdata.tar.gz)

sed  -i "s|UserDataReplaceMe|$UserData|g" guacamole_code/guacamole_cloudformation.yml
