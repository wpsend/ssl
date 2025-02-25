#!/bin/bash

# নির্দিষ্ট IP ব্যবহার করার জন্য প্রক্সি সেটআপ
PROXY_IP="103.174.152.54"   # আপনার নির্দিষ্ট IP
TARGET_SERVER="your.target.server.com"  # আপনার লক্ষ্য সার্ভারের ঠিকানা
PORT=443  # সাধারণত HTTPS ব্যবহৃত হয় (আপনি যদি HTTP ব্যবহার করেন তবে 80 পোর্ট ব্যবহার করুন)

# প্রতিরোধ সিস্টেমের জন্য iptables কনফিগারেশন
echo "Proxy IP Spoofing সেটআপ শুরু হচ্ছে..."

# আপনার VPS সার্ভারের বর্তমান IP চেক করা
VPS_IP=$(curl -s ifconfig.me)

echo "বর্তমান VPS IP: $VPS_IP"

# iptables এর মাধ্যমে নির্দিষ্ট IP এর মাধ্যমে ট্রাফিক রাউটিং
iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $PROXY_IP:$PORT
iptables -t nat -A POSTROUTING -p tcp --dport $PORT -j SNAT --to-source $VPS_IP

# DNS এর মাধ্যমে প্রক্সি সেট আপ করতে হবে (যদি DNS proxy ব্যবহার করেন)
echo "প্রক্সি সেটআপ সম্পন্ন!"
