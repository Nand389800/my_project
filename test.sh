#!/bin/bash

# Install dependencies
sudo yum update -y
sudo yum install httpd php gcc glibc glibc-common gd gd-devel make net-snmp -y

# Install Nagios
cd /tmp
curl -L -O https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar xvf nagios-4.4.6.tar.gz
cd nagioscore-nagios-4.4.6/
sudo ./configure --with-httpd-conf=/etc/httpd/conf.d
sudo make all
sudo make install
sudo make install-init
sudo make install-commandmode
sudo make install-config
sudo make install-webconf

# Add user nagios 
useradd -r nagios

# Install Nagios Plugins
cd /tmp
curl -L -O https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar xvf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3/
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios
sudo make
sudo make install

# Configure Nagios
password="nagios123"
sudo htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios123

# Print the generated password
echo "nagiosadmin password: $password"
sudo systemctl enable nagios
sudo systemctl start nagios
sudo systemctl enable httpd
sudo systemctl restart nagios
sudo systemctl restart httpd

