echo "=== Service Status Check ==="
echo "SSH: $(systemctl is-active sshd)"
echo "Firewall: $(systemctl is-active firewalld)"
echo "System Logging: $(systemctl is-active rsyslog)"
