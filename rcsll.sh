#!/bin/bash

echo "🔍 Checking System..."
OS=$(cat /etc/os-release | grep ^ID= | cut -d= -f2)

if [[ "$OS" != "almalinux" && "$OS" != "cloudlinux" ]]; then
    echo "❌ Unsupported OS! This script is only for AlmaLinux & CloudLinux."
    exit 1
fi

echo "✅ OS Supported: $OS"
echo "🔄 Updating system..."
yum update -y

# Dante Proxy Server Installation
echo "🔹 Installing Dante SOCKS5 Proxy..."
yum install -y epel-release dante-server

echo "🔧 Configuring Dante Server..."
cat > /etc/danted.conf <<EOL
logoutput: syslog
internal: 0.0.0.0 port = 1080
external: eth0
method: none
user.privileged: root
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
EOL

echo "🛠️ Enabling Dante Service..."
systemctl enable danted --now
systemctl restart danted

# IPTables Rule to Route Traffic via Proxy
echo "🔄 Redirecting Traffic via 103.174.152.54..."
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 103.174.152.54
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 103.174.152.54
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "✅ Setup Complete!"
echo "🌍 Proxy is running on port 1080"
