#!/usr/bin/env bash

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "192.168.2.11 mdw #master" >> /etc/hosts
echo "192.168.2.12 smdw #standby" >> /etc/hosts
echo "192.168.2.13 sdw1 #slave2" >> /etc/hosts
echo "192.168.2.14 sdw2 #slave2" >> /etc/hosts
yum install expect -y

/usr/bin/expect<<EOF
spawn  su - root
expect "Password"
send  "\r"
expect
EOF

/usr/bin/expect<<EOF
spawn ssh-keygen -t rsa
expect "Enter file in which to save the key (/root/.ssh/id_rsa): "
send  "\r"
expect "Enter passphrase (empty for no passphrase): "
send  "\r"
expect "Enter same passphrase again: "
send  "\r"
expect
EOF

cd
cat .ssh/id_rsa.pub >> .ssh/authorized_keys

/usr/bin/expect<<EOF
spawn scp -r .ssh/ smdw:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"

expect
EOF

/usr/bin/expect<<EOF
spawn scp -r .ssh/ sdw1:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"

expect
EOF

/usr/bin/expect<<EOF
spawn scp -r .ssh/ sdw2:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

echo "kernel.shmmax = 500000000" > /etc/sysctl.conf
echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
echo "kernel.shmall = 4000000000" >> /etc/sysctl.conf
echo "kernel.sem = 250 512000 100 2048" >> /etc/sysctl.conf
echo "kernel.sysrq = 1" >> /etc/sysctl.conf
echo "kernel.core_uses_pid = 1" >> /etc/sysctl.conf
echo "kernel.msgmnb = 65536" >> /etc/sysctl.conf
echo "kernel.msgmax = 65536" >> /etc/sysctl.conf
echo "kernel.msgmni = 2048" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.arp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1025 65535" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 10000" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
echo "vm.overcommit_memory = 2" >> /etc/sysctl.conf


scp /var/local/sysctl.conf smdw:/etc
scp /var/local/sysctl.conf sdw1:/etc
scp /var/local/sysctl.conf sdw2:/etc

echo "*soft nofile 65536" >> /etc/security/limits.conf
echo "*hard nofile 65536" >> /etc/security/limits.conf
echo "*soft nproc  131072" >> /etc/security/limits.conf
echo "*hard nproc  131072" >> /etc/security/limits.conf

scp /var/local/limits.conf smdw:/etc/security
scp /var/local/limits.conf sdw1:/etc/security
scp /var/local/limits.conf sdw2:/etc/security