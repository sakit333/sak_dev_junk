#!/bin/bash
# ----------------------------------------------
# Designed and developed by: sak_shetty
# Purpose: Install and configure Jenkins on Ubuntu 24.04
# Logs: /var/log/jenkins_install.log
# ----------------------------------------------

# === Colors ===
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# === Style Helpers ===
print_section() {
    echo -e "\n${CYAN}${BOLD}=========================================================${RESET}"
    echo -e "${YELLOW}${BOLD}$1${RESET}"
    echo -e "${CYAN}${BOLD}=========================================================${RESET}"
}

print_step() {
    echo -e "${BLUE}${BOLD}➡️  $1${RESET}"
}

print_done() {
    echo -e "${GREEN}${BOLD}✅ $1${RESET}"
}

# === Script starts ===
set -e
set -o pipefail

LOG_FILE="/var/log/jenkins_install.log"
JENKINS_KEYRING="/etc/apt/keyrings/jenkins-keyring.asc"
JENKINS_REPO="/etc/apt/sources.list.d/jenkins.list"

# Start logging all output to file and console
exec > >(tee -a "$LOG_FILE") 2>&1

clear
echo -e "${MAGENTA}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║            🚀 Jenkins Auto Installer for Ubuntu 24.04            ║"
echo "║                    Designed & Developed by: sak_shetty           ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "${CYAN}${BOLD}Log file:${RESET} $LOG_FILE"
echo

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}❌ This script must be run as root.${RESET} Try: ${YELLOW}sudo bash install_jenkins.sh${RESET}"
    exit 1
fi

echo -e "${YELLOW}${BOLD}🕒 Script started at: $(date)${RESET}"
echo

# Update system
print_section "🔄 Updating System Packages"
apt update -y
print_done "System packages updated successfully."

# Install Java
print_section "☕ Checking for OpenJDK 17"
if ! dpkg -l | grep -q openjdk-17-jre-headless; then
    print_step "Installing OpenJDK 17..."
    apt install -y openjdk-17-jre-headless
    print_done "OpenJDK 17 installed successfully."
else
    print_done "OpenJDK 17 already installed."
fi

# Add Jenkins repo
print_section "🔑 Configuring Jenkins Repository"
if [ ! -f "$JENKINS_KEYRING" ]; then
    print_step "Adding Jenkins GPG key and repository..."
    mkdir -p /etc/apt/keyrings
    wget -q -O "$JENKINS_KEYRING" https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=$JENKINS_KEYRING] https://pkg.jenkins.io/debian-stable binary/" \
        | tee "$JENKINS_REPO" > /dev/null
    apt update -y
    print_done "Jenkins repository added successfully."
else
    print_done "Jenkins repository already exists."
fi

# Install Jenkins
print_section "🚀 Installing Jenkins"
if ! dpkg -l | grep -q jenkins; then
    print_step "Installing Jenkins..."
    apt install -y jenkins
    print_done "Jenkins installed successfully."
else
    print_done "Jenkins already installed."
fi

# Enable and start Jenkins
print_section "⚙️ Starting Jenkins Service"
systemctl enable jenkins
systemctl start jenkins
sleep 10
systemctl status jenkins --no-pager | grep "Active:" || true
print_done "Jenkins service started and enabled."

# Display Jenkins version
print_section "📦 Jenkins Version"
jenkins --version || echo -e "${RED}⚠️ Jenkins command not found (check PATH).${RESET}"

# Grant passwordless sudo
print_section "🔐 Configuring Sudo Access"
if ! grep -q "^jenkins ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    print_step "Granting Jenkins passwordless sudo access..."
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    print_done "Sudo access granted to Jenkins."
else
    print_done "Jenkins already has passwordless sudo access."
fi

# Print Jenkins default path
print_section "📁 Jenkins Default Path"
JENKINS_HOME=$(getent passwd jenkins | cut -d: -f6)
echo -e "${GREEN}${BOLD}Jenkins Home Directory:${RESET} $JENKINS_HOME"

# Fetch initial admin password
print_section "🔑 Jenkins Initial Admin Password"
ADMIN_PASS_FILE="/var/lib/jenkins/secrets/initialAdminPassword"
if [ -f "$ADMIN_PASS_FILE" ]; then
    ADMIN_PASS=$(cat "$ADMIN_PASS_FILE")
    echo -e "${GREEN}${BOLD}Initial Jenkins Admin Password:${RESET} ${YELLOW}$ADMIN_PASS${RESET}"
    echo "--------------------------------------------------------"
    echo "Initial Jenkins password: $ADMIN_PASS" >> "$LOG_FILE"
else
    echo -e "${RED}${BOLD}⚠️ Jenkins initial password not found yet (service may still be starting).${RESET}"
fi

# Final Summary
print_section "✅ Installation Summary"
echo -e "${GREEN}${BOLD}✔ Jenkins installation completed successfully!${RESET}"
echo -e "${CYAN}${BOLD}🌐 Access Jenkins at:${RESET} http://<your-server-ip>:8080"
echo -e "${CYAN}${BOLD}📘 Log file:${RESET} $LOG_FILE"
echo -e "${YELLOW}${BOLD}🕒 Completed at:${RESET} $(date)"
echo

echo -e "${MAGENTA}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║          Jenkins is ready! Login with your initial password     ║"
echo "║            Thank you for using sak_shetty’s installer!           ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
