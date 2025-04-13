#!/bin/bash

# LinuxRecon.sh - Comprehensive Linux Enumeration Script
# Author: 0xproxychains (GitHub: darkarmy66)
# Usage: ./LinuxRecon.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}"
echo ".__                   __   "  
echo "|  |    ____   ____  |  |  "  
echo "|  |   / __ \_/ __ \ |  |  "  
echo "|  |__/ /_/  >  ___/ |  |__"  
echo "|____/\___  / \___  >|____/"  
echo "         \/      \/        "
echo -e "${NC}"


# Create output directory
mkdir -p recon_results 2>/dev/null

# Function to run commands with error handling
run_cmd() {
    echo -e "${BLUE}[*] Running: $1${NC}"
    eval "$1" > "recon_results/$2" 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Successfully saved to recon_results/$2${NC}"
        cat "recon_results/$2"
    else
        echo -e "${RED}[-] Error occurred (check recon_results/$2)${NC}"
    fi
    echo "----------------------------------------"
}

# ========== SYSTEM INFORMATION ==========
echo -e "${YELLOW}[=== SYSTEM INFORMATION ===]${NC}"

run_cmd "uname -a" "kernel_version.txt"
run_cmd "cat /etc/*-release" "os_release.txt"
run_cmd "hostname" "hostname.txt"
run_cmd "cat /proc/version" "proc_version.txt"

# ========== USER INFORMATION ==========
echo -e "${YELLOW}[=== USER INFORMATION ===]${NC}"

run_cmd "id" "current_user.txt"
run_cmd "whoami" "whoami.txt"
run_cmd "cat /etc/passwd" "passwd.txt"
run_cmd "cat /etc/group" "group.txt"
run_cmd "sudo -l" "sudo_permissions.txt"
run_cmd "find / -perm -4000 -type f 2>/dev/null" "suid_binaries.txt"
run_cmd "find / -perm -2000 -type f 2>/dev/null" "sgid_binaries.txt"

# ========== NETWORK INFORMATION ==========
echo -e "${YELLOW}[=== NETWORK INFORMATION ===]${NC}"

run_cmd "ifconfig -a || ip a" "network_interfaces.txt"
run_cmd "netstat -tulnp || ss -tulnp" "listening_ports.txt"
run_cmd "arp -a" "arp_cache.txt"
run_cmd "cat /etc/hosts" "hosts_file.txt"

# ========== PROCESSES & SERVICES ==========
echo -e "${YELLOW}[=== PROCESSES & SERVICES ===]${NC}"

run_cmd "ps aux" "processes.txt"
run_cmd "systemctl list-units --type=service --state=running" "services.txt"
run_cmd "service --status-all 2>/dev/null" "legacy_services.txt"

# ========== CRON JOBS ==========
echo -e "${YELLOW}[=== CRON JOBS ===]${NC}"

run_cmd "cat /etc/crontab" "crontab.txt"
run_cmd "ls -la /etc/cron.*" "cron_directories.txt"
run_cmd "crontab -l" "user_crontab.txt"

# ========== FILE SYSTEM ==========
echo -e "${YELLOW}[=== FILE SYSTEM ===]${NC}"

run_cmd "find / -writable -type f 2>/dev/null | grep -v '/proc/'" "writable_files.txt"
run_cmd "find / -name '*flag*' 2>/dev/null" "flag_files.txt"
run_cmd "find / -name '*.conf' -type f 2>/dev/null" "config_files.txt"
run_cmd "ls -la /home/*" "home_directories.txt"

# ========== PACKAGE INFORMATION ==========
echo -e "${YELLOW}[=== PACKAGE INFORMATION ===]${NC}"

run_cmd "dpkg -l || rpm -qa" "installed_packages.txt"
run_cmd "sudo --version" "sudo_version.txt"
run_cmd "pkexec --version" "pkexec_version.txt"

# ========== ENVIRONMENT ==========
echo -e "${YELLOW}[=== ENVIRONMENT ===]${NC}"

run_cmd "env" "environment_vars.txt"
run_cmd "echo \$PATH" "path_variable.txt"
run_cmd "cat ~/.bash_history" "bash_history.txt"

# ========== SUMMARY ==========
echo -e "${GREEN}"
echo "[+] Enumeration complete!"
echo "Results saved to: recon_results/"
echo -e "${NC}"
echo "To quickly review key findings:"
echo -e "  ${BLUE}grep -r 'interesting_pattern' recon_results/${NC}"
echo -e "  ${BLUE}ls -la recon_results/${NC}"
