#!/bin/bash

source /tmp/env.sh
# default parameters for guacamole server/agent
export LIBJPEG_VER="1.5.2"
export GUACA_VER="1.2.0"
export GUACA_PORT="4822"
export LIB_DIR="/etc/guacamole/"
export GUACAMOLE_URIPATH="guacamole"
export INSTALL_DIR="/usr/local/src/guacamole/${GUACA_VER}/"
export LIBJPEG_URL="http://sourceforge.net/projects/libjpeg-turbo/files/${LIBJPEG_VER}"
export PKG_REPO="http://mirror.centos.org/centos/7/os/x86_64/Packages"
export GUACA_URL="https://downloads.apache.org/guacamole/${GUACA_VER}/"

# Default parameters for MySQL Database
export MYSQL_CONNECTOR_VER="5.1.44"
export MYSQ_CONNECTOR_URL="http://dev.mysql.com/get/Downloads/Connector-J/"
export MYSQL_CONNECTOR="mysql-connector-java-${MYSQL_CONNECTOR_VER}"
export GUACA_CONF="guacamole.properties"
export REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`



# Nginx parameters
export noprompt="-noprompt -dname CN=,OU=,O=,L=,S=,C="
export subj="-subj /C=XX/ST=/L=City/O=Company/CN=/"
export GUACASERVER_HOSTNAME="localhost"

# General paramters
export MACHINE_ARCH=`uname -m`
export SERVER_HOSTNAME="localhost"
export TIME_FORMAT=$(date +"%m-%d-%Y_%H:%M:%S")
export LOG_PATH="/var/log/guacamole-${GUACA_VER}_${TIME_FORMAT}.log"
export TEE_CMD="tee -a ${LOG_PATH}"
export EC2_DOMAIN="${EC2_DOMAIN:-localdomain}"
export ETC_NETWORK_CONFIG="/etc/sysconfig/network"
export ETC_HOSTS="/etc/hosts"


#### List of functions started .....


# generate the overall installations log under ${LOG_PATH} path
log (){
  msg=$*
  echo "${TIME_FORMAT} -  $1" |tee -a ${LOG_PATH}
}




config_db () {
  log "Configuring the MySQL DB ..."


echo "# Hostname and port of guacamole proxy
guacd-hostname: ${SERVER_HOSTNAME}
guacd-port:     ${GUACA_PORT}
# MySQL properties
mysql-hostname: ${MYSQL_SERVER_NAME}
mysql-port: ${MYSQL_PORT}
mysql-database: ${DB_NAME}
mysql-username: ${DB_USER}
mysql-password: ${DB_PASSWD}
mysql-default-max-connections-per-user: 0
mysql-default-max-group-connections-per-user: 0" > /etc/guacamole/${GUACA_CONF} | ${TEE_CMD}

  ln -vs ${LIB_DIR} /usr/share/tomcat/.guacamole | ${TEE_CMD}
  
  cd ${INSTALL_DIR}
  ln -vfs /usr/local/lib/freerdp/guac* /usr/lib64/freerdp | ${TEE_CMD}
  cp -v extension/mysql/guacamole-auth-jdbc-mysql-${GUACA_VER}.jar  ${LIB_DIR}/extensions/
  cp -v mysql-connector-java-${MYSQL_CONNECTOR_VER}/mysql-connector-java-${MYSQL_CONNECTOR_VER}-bin.jar ${LIB_DIR}/lib/ | ${TEE_CMD}
  
  chown -R root:tomcat /etc/guacamole

  if [[ ! $(mysql -h ${MYSQL_SERVER_NAME} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -e "show databases"|grep ${DB_NAME}) ]]
  then
    mysql -h ${MYSQL_SERVER_NAME} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -e "CREATE DATABASE ${DB_NAME};" | ${TEE_CMD}
    mysql -h ${MYSQL_SERVER_NAME} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -e "GRANT SELECT,INSERT,UPDATE,DELETE ON ${DB_NAME}.* TO '${DB_USER}' IDENTIFIED BY '${DB_PASSWD}';" | ${TEE_CMD}
    mysql -h ${MYSQL_SERVER_NAME} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -e "FLUSH PRIVILEGES;" | ${TEE_CMD}
    cat extension/mysql/schema/*.sql | mysql -h ${MYSQL_SERVER_NAME} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -D ${DB_NAME} | ${TEE_CMD}
  else
   log "DB already created ...."
  fi
}


config_tomcat () {
  log "Configuring the Tomcat App ..."
  sed -i '72i URIEncoding="UTF-8"' /etc/tomcat/server.xml  | ${TEE_CMD}

sed -i '92i <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true" \
               maxThreads="150" scheme="https" secure="true" \
               clientAuth="false" sslProtocol="TLS" \
               keystoreFile="/var/lib/tomcat/webapps/.keystore" \
               keystorePass="JKSTORE_PASSWD" \
               URIEncoding="UTF-8" />' /etc/tomcat/server.xml | ${TEE_CMD}

  sed -i "s/JKSTORE_PASSWD/${JKSTORE_PASSWD}/g" /etc/tomcat/server.xml  | ${TEE_CMD}
  keytool -genkey -alias Guacamole -keyalg RSA -keystore /var/lib/tomcat/webapps/.keystore -storepass ${JKSTORE_PASSWD} -keypass ${JKSTORE_PASSWD} ${noprompt} | ${TEE_CMD}
cat > /tmp/valve.xml <<EOF
    <Valve className="org.apache.catalina.valves.RemoteIpValve"
               internalProxies="127.0.0.1|0:0:0:0:0:0:0:1|::1"
               remoteIpHeader="x-forwarded-for"
               remoteIpProxiesHeader="x-forwarded-by"
               protocolHeader="x-forwarded-proto" />
EOF

  sed -ie $'/\/Host>/{e cat /tmp/valve.xml\n}' /etc/tomcat/server.xml 

  systemctl enable tomcat.service | ${TEE_CMD}
  systemctl start tomcat.service | ${TEE_CMD}
  chkconfig guacd on | ${TEE_CMD}
  systemctl start guacd.service | ${TEE_CMD}
}


config_nginx () {
  log "Configuring the nginx App ..."
  mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.ori.bkp | ${TEE_CMD}

echo 'server {
    listen 80;
    server_name localhost;
	location /_new-path_/ {
    	proxy_pass http://_SERVER_HOSTNAME_:8080/guacamole/;
    	proxy_buffering off;
    	proxy_http_version 1.1;
    	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    	proxy_set_header Upgrade $http_upgrade;
    	proxy_set_header Connection $http_connection;
    	proxy_cookie_path /guacamole/ /_new-path_/;
    	access_log off;
	}
}' > /etc/nginx/conf.d/guacamole.conf | ${TEE_CMD}

  sed -i "s/_SERVER_HOSTNAME_/${GUACASERVER_HOSTNAME}/g" /etc/nginx/conf.d/guacamole.conf
  sed -i "s/_new-path_/${GUACAMOLE_URIPATH}/g" /etc/nginx/conf.d/guacamole.conf


echo 'server {
	listen              443 ssl http2;
	server_name         localhost;
	ssl_certificate     guacamole.crt;
	ssl_certificate_key guacamole.key;
	ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers         HIGH:!aNULL:!MD5;
	location /_new-path_/ {
		proxy_pass http://_SERVER_HOSTNAME_:8080/guacamole/;
		proxy_buffering off;
		proxy_http_version 1.1;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $http_connection;
		proxy_cookie_path /guacamole/ /_new-path_/;
		access_log off;
    }
}' > /etc/nginx/conf.d/guacamole_ssl.conf | ${TEE_CMD}
  sed -i "s/_SERVER_HOSTNAME_/${GUACASERVER_HOSTNAME}/g" /etc/nginx/conf.d/guacamole_ssl.conf
  sed -i "s/_new-path_/${GUACAMOLE_URIPATH}/g" /etc/nginx/conf.d/guacamole_ssl.conf

  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/guacamole.key -out /etc/nginx/guacamole.crt ${subj} | ${TEE_CMD}
  systemctl enable nginx.service | ${TEE_CMD}
  systemctl start nginx.service | ${TEE_CMD}

}


selinux () {
  log "Set the selinux permissions ..."
  # Set Booleans
  setsebool -P httpd_can_network_connect 1 | ${TEE_CMD}
  setsebool -P httpd_can_network_relay 1 | ${TEE_CMD}
  setsebool -P tomcat_can_network_connect_db 1 | ${TEE_CMD}


  # Guacamole JDBC Extension Context
  semanage fcontext -a -t tomcat_exec_t "${LIB_DIR}extensions/guacamole-auth-jdbc-mysql-${GUACA_VER}.jar" | ${TEE_CMD}
  restorecon -v "${LIB_DIR}extensions/guacamole-auth-jdbc-mysql-${GUACA_VER}.jar" | ${TEE_CMD}

  # MySQL Connector Extension Context
  semanage fcontext -a -t tomcat_exec_t "${LIB_DIR}lib/${MYSQL_CONNECTOR}-bin.jar" | ${TEE_CMD}
  restorecon -v "${LIB_DIR}lib/${MYSQL_CONNECTOR}-bin.jar" | ${TEE_CMD}
  
  # allow rds connection
  chown root:tomcat -R /etc/guacamole
  #chown root:root /usr/share/tomcat/.guacamole/lib/mysql-connector-java-${MYSQL_CONNECTOR_VER}-bin.jar
  #restorecon -R /usr/share/tomcat/.guacamole /usr/share/tomcat/.guacamole/lib
}

restart_services () {
  log "Restarting the services...."
  systemctl restart tomcat nginx guacd |  ${TEE_CMD}
}

check_services () {
    if systemctl status nginx tomcat guacd 1>/dev/null 
    then
      log "All services are running"
      cfn-signal -e 0 --stack ${STACK_NAME} --resource ${RESOURCE}  --region ${REGION}
    else
      log "Some of the service not running"
      cfn-signal -e 1 --stack ${STACK_NAME} --resource ${RESOURCE} --region ${REGION}
    fi

}

set_hostname () {
  hostnamectl set-hostname "${EC2_HOSTNAME}.${EC2_DOMAIN}" --static | ${TEE_CMD}
  hostnamectl set-hostname "${EC2_HOSTNAME}.${EC2_DOMAIN}" | ${TEE_CMD}

  log "Updating the host entry"
  # Update the host entry /etc/sysconfig/network file
  sed -i -e "/^HOSTNAME/s/^.*$/HOSTNAME=${EC2_HOSTNAME}.${EC2_DOMAIN}/" ${ETC_NETWORK_CONFIG}

  export LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
  echo "${LOCAL_IP} ${EC2_HOSTNAME} ${EC2_HOSTNAME}.${EC2_DOMAIN}" >> ${ETC_HOSTS}

}
set_hostname
config_db
config_nginx
config_tomcat
selinux
restart_services
check_services
#
