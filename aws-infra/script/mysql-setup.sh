#!/bin/bash
exec > >(tee /var/log/mysql-setup.log) 2>&1

# Update system
apt update
apt upgrade -y

# Install MySQL server
apt-get install -y mysql-server

# Configure MySQL to allow remote connections
sed -i 's/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Create database and user
mysql -e "CREATE DATABASE practice_app;"
mysql -e "CREATE USER 'sifat'@'%' IDENTIFIED BY 'sifat';"
mysql -e "GRANT ALL PRIVILEGES ON practice_app.* TO 'sifat'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Restart MySQL
systemctl restart mysql
