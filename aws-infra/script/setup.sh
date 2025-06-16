#!/bin/bash
exec > >(tee /var/log/setup.log) 2>&1

# Update system and install dependencies
apt-get update
apt-get upgrade -y
apt-get install -y netcat-openbsd mysql-client

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Create script directory
mkdir -p /usr/local

cp -r /tmp/app/api /usr/local


# Wait for environment variable to be set
max_attempts=30 
attempt=0

while [ -z "$DB_HOST" ]; do
    if [ $attempt -ge $max_attempts ]; then
        echo "Timeout waiting for DB_HOST to be set"
        exit 1
    fi
    echo "Waiting for DB_HOST environment variable..."
    attempt=$((attempt + 1))
    sleep 10
    # Source the environment file only once per iteration
    source /etc/environment
done

echo "DB_HOST is set to: $DB_HOST"

# Wait for MySQL server to be ready
echo "Waiting for MySQL server to be ready..."
sleep 60

cat > /etc/systemd/system/node.service << "EOF"
[Unit]
Description="Node.js API Service"
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/api
EnvironmentFile=/etc/environment
Environment=DB_PORT=3306
Environment=DB_USER=sifat
Environment=DB_PASSWORD=sifat
Environment=DB_NAME=practice_app
Environment=NODE_ENV=production
Environment=PORT=4000
ExecStartPre=/usr/bin/npm ci --prefix /usr/local/api --production
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=10
StandardOutput=syslog
StandardError=syslog
Environment=PATH=/usr/bin:/usr/local/bin

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable node.service
systemctl start node.service



