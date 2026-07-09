#!/bin/bash

set -e

MYSQL_ROOT_PASSWORD="1234"
MYSQL_CONF="/etc/mysql/mysql.conf.d/mysqld.cnf"

echo "========================================"
echo "MySQL Setup Script"
echo "========================================"

# Update package list

sudo apt update

# Install MySQL only if not installed

if command -v mysql >/dev/null 2>&1; then
echo "✅ MySQL is already installed. Skipping installation."
else
echo "📦 Installing MySQL..."
sudo apt install -y mysql-server
fi

# Display version

echo "📋 MySQL Version:"
mysql --version

# Start MySQL if not running

if systemctl is-active --quiet mysql; then
echo "✅ MySQL service is already running."
else
echo "🚀 Starting MySQL service..."
sudo systemctl start mysql
fi

# Create/update remote root user

echo "🔧 Configuring MySQL users..."

sudo mysql <<EOF
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Configure bind-address

if grep -q "^bind-address = 0.0.0.0" "$MYSQL_CONF"; then
echo "✅ Remote access already enabled."
else
echo "🌐 Enabling remote access..."

sudo cp "$MYSQL_CONF" "${MYSQL_CONF}.bak" 2>/dev/null || true
sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$MYSQL_CONF"
sudo systemctl restart mysql

fi

# Enable service at boot

sudo systemctl enable mysql >/dev/null 2>&1

echo ""
echo "📋 MySQL Users:"
sudo mysql -e "SELECT user,host,plugin FROM mysql.user;"

echo ""
echo "📋 Listening Ports:"
sudo ss -tulpn | grep 3306 || true

echo ""
echo "========================================"
echo "✅ Setup Complete"
echo "========================================"
echo "Username : root"
echo "Password : ${MYSQL_ROOT_PASSWORD}"
echo "Port     : 3306"
echo "========================================"
