#!/bin/bash
# ----------------------------------------------
# Designed and developed by: sak_shetty
# Purpose: Install and configure Jenkins on Ubuntu 24.04
# Logs: /var/log/jenkins_install.log
# ----------------------------------------------

set -e  # Exit on error
set -o pipefail

LOG_FILE="/var/log/jenkins_install.log"
JENKINS_KEYRING="/etc/apt/keyrings/jenkins-keyring.asc"
JENKINS_REPO="/etc/apt/sources.list.d/jenkins.list"

# Start logging all output to file and console
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==============================================="
echo "   Designed and Developed by: sak_shetty"
echo "   Jenkins Auto Installer for Ubuntu 24.04"
echo "   Log file: $LOG_FILE"
echo "==============================================="

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root. Try: sudo bash install_jenkins.sh"
    exit 1
fi

# Timestamp
echo "🕒 Script started at: $(date)"
echo "-----------------------------------------------"

# Update system
echo "🔄 Updating package list..."
apt update -y

# Install Java (OpenJDK 17)
if ! dpkg -l | grep -q openjdk-17-jre-headless; then
    echo "☕ Installing OpenJDK 17..."
    apt install -y openjdk-17-jre-headless
else
    echo "✅ OpenJDK 17 already installed."
fi

# Add Jenkins repository if not already added
if [ ! -f "$JENKINS_KEYRING" ]; then
    echo "🔑 Adding Jenkins GPG key and repository..."
    mkdir -p /etc/apt/keyrings
    wget -q -O "$JENKINS_KEYRING" https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=$JENKINS_KEYRING] https://pkg.jenkins.io/debian-stable binary/" \
        | tee "$JENKINS_REPO" > /dev/null
    apt update -y
else
    echo "✅ Jenkins keyring already exists."
fi

# Install Jenkins if not installed
if ! dpkg -l | grep -q jenkins; then
    echo "🚀 Installing Jenkins..."
    apt install -y jenkins
else
    echo "✅ Jenkins already installed."
fi

# Enable and start Jenkins
echo "⚙️  Enabling and starting Jenkins service..."
systemctl enable jenkins
systemctl start jenkins

# Wait briefly to ensure Jenkins initializes
sleep 10

# Show Jenkins status
echo "📊 Checking Jenkins service status..."
systemctl status jenkins --no-pager | grep "Active:" || true

# Display Jenkins version
echo "📦 Jenkins version:"
jenkins --version || echo "⚠️ Jenkins command not found (check PATH)."

# Grant passwordless sudo for Jenkins user if not already set
if ! grep -q "^jenkins ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    echo "🔐 Adding Jenkins user to sudoers (NOPASSWD)..."
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
else
    echo "✅ Jenkins already has passwordless sudo access."
fi

# Print Jenkins default path
JENKINS_HOME=$(getent passwd jenkins | cut -d: -f6)
echo "📁 Jenkins default home directory: $JENKINS_HOME"

# Fetch Jenkins initial admin password
ADMIN_PASS_FILE="/var/lib/jenkins/secrets/initialAdminPassword"
if [ -f "$ADMIN_PASS_FILE" ]; then
    ADMIN_PASS=$(cat "$ADMIN_PASS_FILE")
    echo "🔑 Initial Jenkins admin password:"
    echo "$ADMIN_PASS"
    echo "-----------------------------------------------"
    echo "Initial Jenkins password: $ADMIN_PASS" >> "$LOG_FILE"
else
    echo "⚠️ Jenkins initial password file not found yet (service may still be starting)."
fi

# Final summary
echo "✅ Jenkins installation completed successfully!"
echo "🌐 Access Jenkins at: http://<your-server-ip>:8080"
echo "📘 Log file saved at: $LOG_FILE"
echo "-----------------------------------------------"
echo "🕒 Script finished at: $(date)"
