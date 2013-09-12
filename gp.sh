#!/usr/bin/env bash

cd /var/local
/usr/bin/expect<<EOF

spawn  /bin/bash greenplum-db-4.2.6.1-build-1-RHEL5-x86_64.bin

expect  "I HAVE READ AND AGREE TO THE TERMS OF THE ABOVE EMC SOFTWARE LICENSE AGREEMENT" 
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
send "\s"
expect {
 "Do you accept the EMC Database license agreement?" 
{
send "yes\r"
exp_continue}
}

expect {
"Provide the installation path for Greenplum Database or press" 
{ send \r"
exp_continue }
}
expect {
 "Install Greenplum Database into" 
{send "yes\r"
exp_continue }
}
expect "/usr/local/greenplum-db" 
send "yes\r"
expect "Provide the path to previous installation"
send "\r"
expect
EOF






