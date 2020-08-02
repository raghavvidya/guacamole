#!/bin/bash


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


# General paramters
export MACHINE_ARCH=`uname -m`
export TIME_FORMAT=$(date +"%m-%d-%Y_%H:%M:%S")
export LOG_PATH="/tmp/guacamole-${GUACA_VER}_${TIME_FORMAT}.log"
export TEE_CMD="tee -a ${LOG_PATH}"
export PIP="/usr/local/bin/pip3.7"

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
              mariadb  \
              mariadb-server | ${TEE_CMD}

  ln -vfs /opt/libjpeg-turbo/include/* /usr/include/ | ${TEE_CMD}
  ln -vfs /opt/libjpeg-turbo/lib??/* /usr/lib64/ | ${TEE_CMD}

  mkdir -v /etc/guacamole | ${TEE_CMD}
  mkdir -vp ${INSTALL_DIR}{client,selinux} | ${TEE_CMD}
  mkdir -vp ${LIB_DIR}{extensions,lib} | ${TEE_CMD}
  ln -vs ${LIB_DIR} /usr/share/tomcat/.guacamole | ${TEE_CMD}

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
  cp -v client/guacamole.war /var/lib/tomcat/webapps/guacamole.war | ${TEE_CMD}
  
  #changing the permissions
  chown -R root:tomcat /etc/guacamole /var/lib/tomcat/webapps/guacamole.war
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


additional_packages () {
  log "Installing the additional Yum packages ..."
  yum install -y \
              emacs \
              libxml2 \
              texlive \
              php \
              libffi-devel \
              openssl-devel \
              postgresql-devel \
              bzip2-devel \
              unixODBC-devel \
              python2-scikit-image.x86_64 \
              scikit-image-tools \
              python-sqlalchemy \
              sqlite \
              zlib-devel \
              gcc-c++ \
              rsync \
              zip \
              git \
              less \
              history \
              util-linux \
              findutils \
              tree \
              screen \
              ctags-etags \
              emacs-auctex \
              binutils \
              glibc \
              nss-softokn-freebl \
              
              openssl-devel  | ${TEE_CMD}            
}



install_python37 () {
  log "Installing the Python3.7 packages ..."
  cd /usr/src
  wget https://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz
  tar xzf Python-3.7.7.tgz
  cd Python-3.7.7
  ./configure --enable-optimizations
  make altinstall
}


install_pip_packages () {
  log "Installing the Pip packages ..."
  ${PIP} install jupyter
  ${PIP} install numpy
  ${PIP} install statistics
  ${PIP} install pandas
  ${PIP} install pandas
  ${PIP} install scipy
  ${PIP} install more-itertools
  ${PIP} install lxml
  ${PIP} install nltk
  ${PIP} install sas7bdat
  ${PIP} install scikit-learn
  ${PIP} install sortedcollections
  ${PIP} install plotly
  ${PIP} install tensorflow
  ${PIP} install rdflib
  ${PIP} install rdflib-jsonld
  ${PIP} install flask
  ${PIP} install flask-script
  ${PIP} install statsmodels
  ${PIP} install sympy
  ${PIP} install seaborn
  ${PIP} install bokeh
  ${PIP} install plotnine
  ${PIP} install numba
  ${PIP} install pyodbc
  ${PIP} install argparse
  ${PIP} install psycopg2  
  ${PIP} install Scikit-image
  ${PIP} install Sqlalchemy
}



create_repo
update_os
guacamole_install
additional_packages
install_python37
install_pip_packages
install_nginx
install_aws
