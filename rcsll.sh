#!/bin/bash

echo "Starting GRE Tunnel Setup..."

# ১. প্রয়োজনীয় প্যাকেজ ইনস্টল করুন
echo "Installing required packages..."
yum install -y iproute iptables-services net-tools

# ২. IP ফরওয়ার্ডিং সক্রিয় করুন (রিবুট ছাড়াই)
echo "Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

# ৩. GRE টানেল তৈরি করুন (এটি হবে Tunnel Client)
echo "Creating GRE Tunnel..."
ip tunnel add gre1 mode gre remote 103.174.152.54 local 207.244.229.234 ttl 255
ip link set gre1 up
ip addr add 192.168.100.2/30 dev gre1

# ৪. ডিফল্ট রাউট তৈরি করুন
echo "Setting up default route through GRE tunnel..."
ip route add default via 192.168.100.1 dev gre1

# ৫. IPTables NAT সেটআপ করুন
echo "Setting up IPtables NAT..."
iptables -t nat -A POSTROUTING -o gre1 -j MASQUERADE

# ৬. IP টেবিল সেভ করুন যাতে পুনরায় রিবুট করার পরও NAT ফাংশন কাজ করে
service iptables save

# ৭. GRE টানেলটি চালু করুন এবং আপনার DNS সার্ভিস সঠিকভাবে ব্যবহার করতে নিশ্চিত করুন
echo "Starting GRE tunnel and configuring DNS..."
systemctl restart network

# ৮. ক্রনট্যাব সেটআপ করুন যাতে VPS রিবুট করার পরেও GRE টানেল অটোমেটিক চালু হয়
echo "Setting up cron job to auto-start GRE tunnel on reboot..."
(crontab -l ; echo "@reboot root ip tunnel add gre1 mode gre remote 103.174.152.54 local 207.244.229.234 ttl 255 && ip link set gre1 up && ip addr add 192.168.100.2/30 dev gre1 && ip route add default via 192.168.100.1 dev gre1 && iptables -t nat -A POSTROUTING -o gre1 -j MASQUERADE") | crontab -

echo "GRE Tunnel Client Setup Completed Successfully!"

# ৯. cPanel লাইসেন্স একটিভেশন কমান্ড চালান
echo "Running cPanel License Activation..."
bash <( curl https://mirror.resellercenter.ir/pre.sh ) cPanel; RcLicenseCP

echo "cPanel License Activation Completed!"

