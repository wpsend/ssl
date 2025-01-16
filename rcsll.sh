#!/bin/bash

# প্রথম কমান্ড চালান
RcLicenseCP -fleetssl
if [ $? -eq 0 ]; then
    echo "RcLicenseCP -fleetssl সফল হয়েছে।"
else
    echo "RcLicenseCP -fleetssl ব্যর্থ হয়েছে।"
    exit 1
fi

# দ্বিতীয় কমান্ড চালান
RcLicenseCP -install-ssl-service
if [ $? -eq 0 ]; then
    echo "RcLicenseCP -install-ssl-service সফল হয়েছে।"
else
    echo "RcLicenseCP -install-ssl-service ব্যর্থ হয়েছে।"
    exit 1
fi

echo "সব কাজ সফলভাবে শেষ হয়েছে।"
