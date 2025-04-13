#!/bin/bash

# LinuxDetective.sh - Automated Linux Enumeration Script
# Author: [0xproxychains]
# GitHub: [darkarmy66]

# Function to print section headers
print_section() {
    echo -e "\n\033[1;34m[+] $1\033[0m"
    echo "----------------------------------------"
}

# Function to run a command and display its output
run_cmd() {
    echo -e "\033[1;32m[*] Executing: $1\033[0m"
    eval "$1"
    echo ""
}

# Start of the script
echo -e "\033[1;33m=== LinuxDetective.sh: System Enumeration Script ===\033[0m"

# 1. User and Process Information
print_section "User and Process Information"
run_cmd "whoami"
run_cmd "id"
run_cmd "hostname"
run_cmd "ps aux | grep root"
run_cmd "ps au"

# 2. Network Information
print_section "Network Information"
run_cmd "ifconfig"
run_cmd "ip a"
run_cmd "arp -a"
run_cmd "netstat -rn"
run_cmd "route"

# 3. System Information
print_section "System Information"
run_cmd "uname -a"
run_cmd "cat /etc/os-release"
run_cmd "lscpu"
run_cmd "cat /etc/shells"
run_cmd "cat /etc/fstab"
run_cmd "cat /etc/resolv.conf"

# 4. Environment Variables
print_section "Environment Variables"
run_cmd "echo \$PATH"
run_cmd "env"

# 5. User Accounts and Groups
print_section "User Accounts and Groups"
run_cmd "cat /etc/passwd"
run_cmd "cat /etc/passwd | cut -f1 -d:"
run_cmd "grep '*sh$' /etc/passwd"
run_cmd "cat /etc/group"
run_cmd "getent group sudo"

# 6. Home Directories and SSH
print_section "Home Directories and SSH"
run_cmd "ls /home"
run_cmd "ls -la /home/*/"
run_cmd "ls -l ~/.ssh"
run_cmd "ls ~/.ssh"

# 7. Command History
print_section "Command History"
run_cmd "history"

# 8. Sudo Permissions
print_section "Sudo Permissions"
run_cmd "sudo -l"
run_cmd "sudo -V"

# 9. Cron Jobs
print_section "Cron Jobs"
run_cmd "ls -la /etc/cron.daily/"
run_cmd "ls -la /etc/cron.daily/"

# 10. Disk and Filesystem Information
print_section "Disk and Filesystem Information"
run_cmd "lsblk"
run_cmd "df -h"
run_cmd "cat /etc/fstab | grep -v '#' | column -t"

# 11. Writable Directories and Files
print_section "Writable Directories and Files"
run_cmd "find / -path /proc -prune -o -type d -perm -o+w 2>/dev/null"
run_cmd "find / -path /proc -prune -o -type f -perm -o+w 2>/dev/null"

# 12. Hidden Files and Directories
print_section "Hidden Files and Directories"
run_cmd "find / -type f -name '.*' -exec ls -l {} \; 2>/dev/null | grep user"
run_cmd "find / -type d -name '.*' -ls 2>/dev/null"

# 13. Temporary Directories
print_section "Temporary Directories"
run_cmd "ls -l /tmp /var/tmp /dev/shm"

# 14. Login Information
print_section "Login Information"
run_cmd "lastlog"
run_cmd "w"

# 15. Command History Files
print_section "Command History Files"
run_cmd "find / -type f \\( -name '*_hist' -o -name '*_history' \\) -exec ls -l {} \; 2>/dev/null"

# 16. Process Command Lines
print_section "Process Command Lines"
run_cmd "find /proc -name cmdline -exec cat {} \; 2>/dev/null | tr '\\0' '\\n'"

# 17. Installed Packages
print_section "Installed Packages"
run_cmd "apt list --installed | tr '/' ' ' | cut -d' ' -f1,3 | sed 's/[0-9]://g' | tee -a installed_pkgs.list"

# 18. Executable Files
print_section "Executable Files"
run_cmd "ls -l /bin /usr/bin/ /usr/sbin/"

# 19. GTFOBins Check
print_section "GTFOBins Check"
run_cmd "for i in \$(curl -s https://gtfobins.github.io/ | html2text | cut -d' ' -f1 | sed '/^[[:space:]]*\$/d'); do if grep -q \"\$i\" installed_pkgs.list; then echo \"Check GTFO for: \$i\"; fi; done"

# 20. Network Tracing
print_section "Network Tracing"
run_cmd "strace ping -c1 example.com"

# 21. Configuration Files
print_section "Configuration Files"
run_cmd "find / -type f \\( -name '*.conf' -o -name '*.config' \\) -exec ls -l {} \; 2>/dev/null"
run_cmd "find / -type f -name '*.sh' 2>/dev/null | grep -v 'src\\|snap\\|share'"
run_cmd "find / -type f -name 'wp-config.php' 2>/dev/null"
run_cmd "find / ! -path '*/proc/*' -iname '*config*' -type f 2>/dev/null"

# End of the script
echo -e "\033[1;33m=== LinuxDetective.sh: Enumeration Complete ===\033[0m"

