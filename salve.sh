#!/usr/bin/env bash

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "192.168.2.11 mdw #master" >> /etc/hosts
echo "192.168.2.12 smdw #standby" >> /etc/hosts
echo "192.168.2.13 sdw1 #slave2" >> /etc/hosts
echo "192.168.2.14 sdw2 #slave2" >> /etc/hosts
yum install expect -y
yum install ntp -y


