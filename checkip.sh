#!/bin/bash
NOTIFICATION=`notification mail address`
URLIP=`curl -s http://ddns.oray.com/checkip | awk -F ": " '{print $2}' | awk -F "<" '{print $1}'`
if [ -a "~/myscript/ip.txt" ]; then
  LOGIP=$(cat ./ip.txt)
else
  curl -s http://ddns.oray.com/checkip | awk -F ": " '{print $2}' | awk -F "<" '{print $1}' >> ~/myscript/ip.txt
fi
if [ "$URLIP" != "$LOGIP" ]; then
  if [ -a "~/myscript/ip_msg.txt" ]; then
    rm ~/myscript/ip_msg.txt
  fi
  rm ~/myscript/ip.txt
  touch ~/myscript/ip.txt
  echo "$URLIP" >> ~/myscript/ip.txt
  cp ~/myscript/ip.txt ~/myscript/Incoming/ip.txt
  touch ~/myscript/ip_msg.txt
  echo "To: renzh@outlook.com" >> ~/myscript/ip_msg.txt
  echo "From: ren.zh@foxmail.com" >> ~/myscript/ip_msg.txt
  echo "Subject: Ubuntu HLG Public IP address rolled!" >> ~/myscript/ip_msg.txt
  echo "" >> ~/myscript/ip_msg.txt
  echo "Current IP is: $URLIP (From:$LOGIP)" >> ~/myscript/ip_msg.txt
  echo "" >> ~/myscript/ip_msg.txt
  ssmtp $NOTFICATION < ~/myscript/ip_msg.txt
fi
