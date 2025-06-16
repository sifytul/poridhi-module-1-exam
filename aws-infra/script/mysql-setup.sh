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
mysql -e "
CREATE DATABASE IF NOT EXISTS practice_app;
CREATE USER 'sifat'@'%' IDENTIFIED BY 'sifat';
GRANT ALL PRIVILEGES ON practice_app.* TO 'sifat'@'%';
FLUSH PRIVILEGES;
"
mysql -e "

USE practice_app;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (name, email) VALUES
    ('John Doe', 'john.doe@example.com'),
    ('Jane Smith', 'jane.smith@example.com'),
    ('Bob Johnson', 'bob.johnson@example.com');
"
# Restart MySQL
systemctl restart mysql
