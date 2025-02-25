#!/bin/bash
echo "GRE Tunnel Client Setup Starting..."

# প্রয়োজনীয় প্যাকেজ ইনস্টল করুন
yum install -y iproute iptables-services

# IP ফরওয়ার্ডিং সক্রিয় করুন (রিবুট ছাড়া)
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

# GRE টানেল তৈরি করুন
ip tunnel add gre1 mode gre remote 103.174.152.54 local 207.244.229.234 ttl 255
ip link set gre1 up
ip addr add 192.168.100.2/30 dev gre1

# ডিফল্ট রাউট সেট করুন যাতে সব ট্রাফিক GRE টানেল দিয়ে যায়
ip route add default via 192.168.100.1 dev gre1

# IPTables NAT সেটআপ করুন (রিবুট ছাড়াই স্থায়ী হবে)
iptables -t nat -A POSTROUTING -o gre1 -j MASQUERADE

echo "✅ GRE Tunnel Client Setup Completed!"
