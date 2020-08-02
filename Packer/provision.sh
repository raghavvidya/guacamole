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
export DOCX2TXT="docx2txt-1.4"

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
export SPREADSHEET_XLSX="Spreadsheet-XLSX-0.15"

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
  
  tar xzf guacamole-auth-ldap-${GUACA_VER}.tar.gz && rm -f guacamole-auth-ldap-${GUACA_VER}.tar.gz | ${TEE_CMD}
  mv guacamole-auth-ldap-${GUACA_VER} extension | ${TEE_CMD}

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
              rdiff-backup \
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
              ftp \
              vsftpd \
              history \
              util-linux \
              findutils \
              tree \
              screen \
              ctags-etags \
              pandoc \
              emacs-auctex \
              binutils \
              glibc \
              perl-CPAN \
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
  ${PIP} install --upgrade pip
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
  ${PIP} install Sorted
}


install_spreadsheetxlsx () {
  log "Installing Perl Spreadsheet XLSx module..."
  mkdir -p /root/.cpan/CPAN
  echo """
 \$CPAN::Config = {
  'applypatch' => q[],
  'auto_commit' => q[0],
  'build_cache' => q[100],
  'build_dir' => q[/root/.cpan/build],
  'build_dir_reuse' => q[0],
  'build_requires_install_policy' => q[yes],
  'bzip2' => q[],
  'cache_metadata' => q[1],
  'check_sigs' => q[0],
  'colorize_output' => q[0],
  'commandnumber_in_prompt' => q[1],
  'connect_to_internet_ok' => q[1],
  'cpan_home' => q[/root/.cpan],
  'ftp_passive' => q[1],
  'ftp_proxy' => q[],
  'getcwd' => q[cwd],
  'gpg' => q[/bin/gpg],
  'gzip' => q[/bin/gzip],
  'halt_on_failure' => q[0],
  'histfile' => q[/root/.cpan/histfile],
  'histsize' => q[100],
  'http_proxy' => q[],
  'inactivity_timeout' => q[0],
  'index_expire' => q[1],
  'inhibit_startup_message' => q[0],
  'keep_source_where' => q[/root/.cpan/sources],
  'load_module_verbosity' => q[none],
  'make' => q[/bin/make],
  'make_arg' => q[],
  'make_install_arg' => q[],
  'make_install_make_command' => q[/bin/make],
  'makepl_arg' => q[],
  'mbuild_arg' => q[],
  'mbuild_install_arg' => q[],
  'mbuild_install_build_command' => q[./Build],
  'mbuildpl_arg' => q[],
  'no_proxy' => q[],
  'pager' => q[/bin/less],
  'patch' => q[],
  'perl5lib_verbosity' => q[none],
  'prefer_external_tar' => q[1],
  'prefer_installer' => q[MB],
  'prefs_dir' => q[/root/.cpan/prefs],
  'prerequisites_policy' => q[follow],
  'scan_cache' => q[atstart],
  'shell' => q[/bin/bash],
  'show_unparsable_versions' => q[0],
  'show_upload_date' => q[0],
  'show_zero_versions' => q[0],
  'tar' => q[/bin/tar],
  'tar_verbosity' => q[none],
  'term_is_latin' => q[1],
  'term_ornaments' => q[1],
  'test_report' => q[0],
  'trust_test_report_history' => q[0],
  'unzip' => q[/bin/unzip],
  'urllist' => [q[http://cpan.mirrors.ionfish.org/], q[http://ftp.wayne.edu/CPAN/], q[http://mirror.its.dal.ca/cpan/]],
  'use_sqlite' => q[0],
  'version_timeout' => q[15],
  'wget' => q[/bin/wget],
  'yaml_load_code' => q[0],
  'yaml_module' => q[YAML],
};
1;
__END__
""" > /root/.cpan/CPAN/MyConfig.pm
  cd /root
  wget https://cpan.metacpan.org/authors/id/M/MI/MIKEB/${SPREADSHEET_XLSX}.tar.gz
  tar xvzf ${SPREADSHEET_XLSX}.tar.gz
  cd ${SPREADSHEET_XLSX}
  perl -MCPAN -e "install Spreadsheet::XLSX"
  cd /root
  rm -rf ${SPREADSHEET_XLSX}*
}


install_docx2txt () {
    log "Installing Docx2Txt ..."
    wget "http://downloads.sourceforge.net/docx2txt/${DOCX2TXT}.tgz?download" -O ${DOCX2TXT}.tgz
    tar xvfz ${DOCX2TXT}.tgz
    cd ${DOCX2TXT}
    cp docx2txt.pl /usr/local/bin/
    chmod +x /usr/local/bin/docx2txt.pl
    cd ../
    rm -rf docx2txt*
}


install_cloudinit () {

  yum install cloud-init
  
  #Allow root login
  sed -i -e 's/disable_root: *1/ssh_pwauth: 0/g' /etc/cloud/cloud.cfg

  #Allow password authentication
  sed -i -e 's/ssh_pwauth: *0/ssh_pwauth: 1/g' /etc/cloud/cloud.cfg
  sed -i -e 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

  #enable all cloud-init services
  systemctl enable cloud-init-local.service
  systemctl enable cloud-init.service
  systemctl enable cloud-config.service
  systemctl enable cloud-final.service

}


create_repo
guacamole_install
additional_packages
install_python37
install_pip_packages
install_spreadsheetxlsx
install_docx2txt
install_nginx
install_cloudinit
install_aws
