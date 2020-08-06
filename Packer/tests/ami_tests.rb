#### All pip packages
control 'PIP-01' do
title 'Make sure at least v1.0.0 Pip package jupyter is installed'
  describe pip('jupyter','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.0.0' }
  end
end

control 'PIP-02' do
title 'Make sure at least v1.18.0 Pip package numpy is installed'
  describe pip('numpy','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.18.0' }
  end
end

control 'PIP-03' do
title 'Make sure at least v1.0.3.5 Pip package statistics is installed'
  describe pip('statistics','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.0.3.5' }
  end
end

control 'PIP-04' do
title 'Make sure at least v1.1.0 Pip package pandas is installed'
  describe pip('pandas','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.1.0' }
  end
end

control 'PIP-05' do
title 'Make sure at least v1.4.1 Pip package scipy is installed'
  describe pip('scipy','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.4.1' }
  end
end

control 'PIP-06' do
title 'Make sure at least v8.4.0 Pip package more-itertools is installed'
  describe pip('more-itertools','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '8.4.0' }
  end
end


control 'PIP-07' do
title 'Make sure at least v4.5.2 Pip package lxml is installed'
  describe pip('lxml','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '4.5.2' }
  end
end

control 'PIP-08' do
title 'Make sure at least v3.5 Pip package nltk is installed'
  describe pip('nltk','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '3.5' }
  end
end

control 'PIP-09' do
title 'Make sure at least v3.5 Pip package nltk is installed'
  describe pip('sas7bdat','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '2.2.3' }
  end
end

control 'PIP-10' do
title 'Make sure at least v0.23.1 Pip package scikit-learn is installed'
  describe pip('scikit-learn','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.23.1' }
  end
end


control 'PIP-11' do
title 'Make sure at least v1.2.1 Pip package sortedcollections is installed'
  describe pip('sortedcollections','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.2.1' }
  end
end


control 'PIP-12' do
title 'Make sure at least v4.9.0 Pip package plotly is installed'
  describe pip('plotly','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '4.9.0' }
  end
end


control 'PIP-13' do
title 'Make sure at least v2.3.0 Pip package tensorflow is installed'
  describe pip('tensorflow','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '2.3.0' }
  end
end


control 'PIP-14' do
title 'Make sure at least v5.0.0 Pip package rdflib is installed'
  describe pip('rdflib','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '5.0.0' }
  end
end

control 'PIP-15' do
title 'Make sure at least v0.5.0 Pip package rdflib-jsonld is installed'
  describe pip('rdflib-jsonld','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.5.0' }
  end
end

control 'PIP-16' do
title 'Make sure at least v1.1.2 Pip package flask is installed'
  describe pip('flask','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.1.2' }
  end
end

control 'PIP-17' do
title 'Make sure at least v2.0.6 Pip package flask-script is installed'
  describe pip('flask-script','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '2.0.6' }
  end
end

control 'PIP-18' do
title 'Make sure at least v0.11.1 Pip package statsmodels is installed'
  describe pip('statsmodels','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.11.1' }
  end
end



control 'PIP-19' do
title 'Make sure at least v1.6.1 Pip package sympy is installed'
  describe pip('sympy','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.6.1' }
  end
end

control 'PIP-20' do
title 'Make sure at least v0.10.1 Pip package seaborn is installed'
  describe pip('seaborn','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.10.1' }
  end
end

control 'PIP-21' do
title 'Make sure at least v2.1.1 Pip package bokeh is installed'
  describe pip('bokeh','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '2.1.1' }
  end
end


control 'PIP-22' do
title 'Make sure at least v0.50.1 Pip package numba is installed'
  describe pip('numba','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.50.1' }
  end
end

control 'PIP-23' do
title 'Make sure at least v4.0.30 Pip package pyodbc is installed'
  describe pip('pyodbc','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '4.0.30' }
  end
end

control 'PIP-24' do
title 'Make sure at least v1.4.0 Pip package argparse is installed'
  describe pip('argparse','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.4.0' }
  end
end

control 'PIP-25' do
title 'Make sure at least v2.8.5 Pip package psycopg2 is installed'
  describe pip('psycopg2','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '2.8.5' }
  end
end

control 'PIP-26' do
title 'Make sure at least v0.17.2 Pip package Scikit-image is installed'
  describe pip('Scikit-image','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.17.2' }
  end
end

control 'PIP-27' do
title 'Make sure at least v1.3.18 Pip package Sqlalchemy is installed'
  describe pip('Sqlalchemy','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '1.3.18' }
  end
end

control 'PIP-28' do
title 'Make sure at least v0.1.0 Pip package Sorted is installed'
  describe pip('Sorted','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.1.0' }
  end
end

control 'PIP-29' do
title 'Make sure at least v0.7.0 Pip package plotnine is installed'
  describe pip('plotnine','/usr/local/bin/pip3.7') do
    it { should be_installed }
    its('version') { should be >= '0.7.0' }
  end
end

#############
######### Yum packages
control 'PKGS-LIST' do
title 'Make sure all these list of packages are installed '
  packages = ["emacs", "libxml2","texlive","php","libffi-devel","cloud-init","nginx","tomcat","openssl-devel","postgresql-devel","bzip2-devel","unixODBC-devel","rdiff-backup","python2-scikit-image.x86_64","scikit-image-tools","python-sqlalchemy","sqlite","zlib-devel","gcc-c++","rsync","zip","git","less","ftp","vsftpd","util-linux","findutils","tree","screen","ctags-etags","ctags","pandoc","emacs-auctex","binutils","glibc","sed","gawk","crontabs","cpp","grep","less","vim-enhanced","perl-CPAN","nss-softokn-freebl","openssl-devel"]
  packages.each do |packagename|
      describe package(packagename) do
          it { should be_installed }
      end
  end
end

control 'PYTHON' do
title 'Make sure installed Python 3.7'
  describe command('/usr/local/bin/python3.7 -V') do
     its('stdout') { should match ('Python 3.7.7') }
  end
end

#### docx2txt
control 'PERL-01' do
title 'Make sure installed docx2txt perl library'
  describe file('/usr/local/bin/docx2txt.pl') do
    it { should be_file }
  end
end


#check perl module
control 'PERL-02' do
title 'Make sure installed Spreadsheet library'
  describe command('perl -e "use Spreadsheet::XLSX"') do
      its('exit_status') { should eq 0 }
  end
end


# guacamole 
control 'GUAC-01' do
title 'Make sure Guacamole packages installed'
  describe file('/etc/guacamole/extensions/guacamole-auth-jdbc-mysql-1.2.0.jar') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'tomcat' }
  end
end

control 'GUAC-02' do
title 'Make sure Guacamole v1.2.0 auth-jdbc-mysql extensions installed'
  describe file('/etc/guacamole/extensions/guacamole-auth-ldap-1.2.0.jar') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'tomcat' }
  end
end

control 'GUAC-03' do
title 'Make sure Guacamole v1.2.0 auth-jdbc-ldap extensions installed'
  describe file('/etc/guacamole/lib/mysql-connector-java-5.1.44-bin.jar') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'tomcat' }
  end
end

control 'GUAC-04' do
title 'Make sure Guacamole v1.2.0 mysql-java-connector library installed'
  describe file('/var/lib/tomcat/webapps/guacamole.war') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'tomcat' }
  end
end

control 'SYS-01' do
title 'Make sure root login is enabled'
## ssh root logins
  describe command('grep "^PasswordAuthentication yes" /etc/ssh/sshd_config') do
      its('stdout') { should eq "PasswordAuthentication yes\n" }
  end
end

control 'mytest' do
title 'Server'
  describe command('grep "^disable_root: 0" /etc/cloud/cloud.cfg') do
      its('stdout') { should eq "disable_root: 0\n" }
  end
end

control 'mytest' do
title 'Server'
  describe command('grep "^ssh_pwauth: 1" /etc/cloud/cloud.cfg') do
      its('stdout') { should eq "ssh_pwauth: 1\n" }
  end
end
