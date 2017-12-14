#!/bin/bash
NOTIFICATION="notification mail address"
URLIP=''
cntipget=5
# to fix issue when ip from URL is none (sometimes), sending fault notification
# 5 times get URLIP
while [ -z "URLIP"]
do
  URLIP=`curl -s http://ddns.oray.com/checkip | awk -F ": " '{print $2}' | awk -F "<" '{print $1}'`
  if [ $cntipget -le 0 ]; then
    break
  fi
  cntipget=`expr $cntipget - 1`
done
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
  echo "Subject:Public IP address rolled!" >> ~/myscript/ip_msg.txt
  echo "" >> ~/myscript/ip_msg.txt
  echo "Current IP is: $URLIP (From:$LOGIP)" >> ~/myscript/ip_msg.txt
  echo "" >> ~/myscript/ip_msg.txt
  /usr/sbin/ssmtp $NOTFICATION < ~/myscript/ip_msg.txt
fi
