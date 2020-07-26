#!/bin/bash


# default parameters for guacamole server/agent
export LIBJPEG_VER="1.5.2"
export GUACA_VER="1.2.0"
export GUACA_PORT="4822"
export LIB_DIR="/var/lib/guacamole/"
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


# General paramters
export MACHINE_ARCH=`uname -m`
export TIME_FORMAT=$(date +"%m-%d-%Y_%H:%M:%S")
export LOG_PATH="/tmp/guacamole-${GUACA_VER}_${TIME_FORMAT}.log"
export TEE_CMD="tee -a ${LOG_PATH}"

#### List of functions started .....


# generate the overall installations log under ${LOG_PATH} path
log (){
  msg=$*
  echo "${TIME_FORMAT} -  $1" |tee -a ${LOG_PATH}
}

install_aws () {
yum install python-pip -y
pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

}

create_repo () {
  log "Creating the repo needed for installing the Guacamole Dependencies"
  yum install -y https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm \
                https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
                https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm | ${TEE_CMD}
}


update_os () {
  log "Running the OS update..."
  yum update -y  | ${TEE_CMD}
}


guacamole_install () {
  log "Installing the Guacamole dependencies packages ..."
  yum install -y \
              cairo-devel \
              libjpeg-turbo-devel \
              libjpeg-devel \
              libpng-devel \
              libtool \
              ${PKG_REPO}/uuid-devel-1.6.2-26.el7.x86_64.rpm \
              ffmpeg-devel \
              ${PKG_REPO}/libwinpr-devel-2.0.0-1.rc4.el7.x86_64.rpm \
              ${PKG_REPO}/freerdp-devel-2.0.0-1.rc4.el7.x86_64.rpm \
              ${PKG_REPO}/libogg-devel-1.3.0-7.el7.x86_64.rpm \
              pango-devel \
              ${PKG_REPO}/libssh2-devel-1.8.0-3.el7.x86_64.rpm \
              libtelnet-devel \
              libvncserver-devel \
              libwebsockets-devel \
              pulseaudio-libs-devel \
              openssl-devel \
              ${PKG_REPO}/libvorbis-devel-1.3.3-8.el7.1.x86_64.rpm \
              ${PKG_REPO}/libwebp-devel-0.3.0-7.el7.x86_64.rpm \
              libwebp-devel   \
              libjpeg-turbo-devel  \
              cairo-devel   \
              libpng-devel    \
              libtool      \
              wget     \
              gcc     \
              tomcat   \
              unzip    \
              libtelnet-devel  \
              libvncserver-devel \
              libwebsockets-devel  \
              openssl-devel  \
              libvorbis-devel \
              mariadb  \
              mariadb-server | ${TEE_CMD}

  ln -vfs /opt/libjpeg-turbo/include/* /usr/include/ | ${TEE_CMD}
  ln -vfs /opt/libjpeg-turbo/lib??/* /usr/lib64/ | ${TEE_CMD}

  mkdir -v /etc/guacamole | ${TEE_CMD}
  mkdir -vp ${INSTALL_DIR}{client,selinux} | ${TEE_CMD}
  mkdir -vp ${LIB_DIR}{extensions,lib} | ${TEE_CMD}
  mkdir -v /usr/share/tomcat/.guacamole/ | ${TEE_CMD}

  cd ${INSTALL_DIR}

  wget --progress=bar:force ${GUACA_URL}source/guacamole-server-${GUACA_VER}.tar.gz | ${TEE_CMD}
  wget --progress=bar:force ${GUACA_URL}binary/guacamole-${GUACA_VER}.war -O ${INSTALL_DIR}client/guacamole.war | ${TEE_CMD}
  wget --progress=bar:force ${GUACA_URL}binary/guacamole-auth-jdbc-${GUACA_VER}.tar.gz | ${TEE_CMD}
  wget --progress=bar:force ${MYSQ_CONNECTOR_URL}${MYSQL_CONNECTOR}.tar.gz | ${TEE_CMD}

  tar xzf guacamole-server-${GUACA_VER}.tar.gz && rm -f guacamole-server-${GUACA_VER}.tar.gz | ${TEE_CMD}
  mv guacamole-server-${GUACA_VER} server | ${TEE_CMD}

  tar xzf guacamole-auth-jdbc-${GUACA_VER}.tar.gz && rm -f guacamole-auth-jdbc-${GUACA_VER}.tar.gz | ${TEE_CMD}
  mv guacamole-auth-jdbc-${GUACA_VER} extension | ${TEE_CMD}

  tar xzf ${MYSQL_CONNECTOR}.tar.gz && rm -f ${MYSQL_CONNECTOR}.tar.gz | ${TEE_CMD}

  cd ${INSTALL_DIR}

  log "Compling the Guacamole server packages ..."
  cd server
  ./configure --with-init-dir=/etc/init.d | ${TEE_CMD}
  make | ${TEE_CMD}
  make install | ${TEE_CMD}
  ldconfig | ${TEE_CMD}
  cd ../

  log "Installing the Guacamole client packages ..."
  cp -v client/guacamole.war ${LIB_DIR}guacamole.war | ${TEE_CMD}
}

install_nginx () {
  log "Configuring the nginx App ..."
echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1' > /etc/yum.repos.d/nginx.repo | ${TEE_CMD}
  yum install -y nginx | ${TEE_CMD}
}


create_repo
update_os
guacamole_install
install_nginx
install_aws
