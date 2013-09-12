#!/usr/bin/env bash

yum install ntp -y
mkdir /rawdata

cd /rawdata
source /usr/local/greenplum-db-4.2.6.1/greenplum_path.sh

echo "mdw" > hostfile_exkeys
echo "smdw" >> hostfile_exkeys
echo "sdw1" >> hostfile_exkeys
echo "sdw2" >> hostfile_exkeys
chmod 777 hostfile_exkeys
gpseginstall -f hostfile_exkeys -u gpadmin -p changeme

cd /
mkdir data
cd data
mkdir master
chown gpadmin:gpadmin /data/master

source /usr/local/greenplum-db-4.2.6.1/greenplum_path.sh
gpssh -h smdw -e 'mkdir -p /data/master'
gpssh -h smdw 'chown gpadmin:gpadmin /data/master'

cd /rawdata
echo "sdw1" > hostfile_gpssh_segonly
echo "sdw2" >> hostfile_gpssh_segonly
chmod 777 hostfile_gpssh_segonly

source /usr/local/greenplum-db-4.2.6.1/greenplum_path.sh
gpssh -f hostfile_gpssh_segonly -e 'mkdir -p /data/primary /data/mirror; chown gpadmin:gpadmin /data/primary /data/mirror'
gpssh -h sdw1 -e 'mkdir /loaddata'
gpssh -h sdw1 -e 'chown -R gpadmin:gpadmin /loaddata'

sed -i 's/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
echo "server 192.168.2.11" >> /etc/ntp.conf

/etc/init.d/ntpd start
gpssh -h sdw1 -e 'sed -i 's/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h sdw1 -e 'sed -i 's/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h sdw1 -e 'sed -i 's/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h sdw1 -e 'echo "server mdw prefer" >> /etc/ntp.conf'
gpssh -h sdw1 -e 'echo "server smdw" >> /etc/ntp.conf'
gpssh -h sdw1 -e '/etc/init.d/ntpd start'
source /usr/local/greenplum-db/greenplum_path.sh
gpscp -h sdw2 /etc/ntp.conf =:/etc/ntp.conf
gpssh -h sdw2 -e '/etc/init.d/ntpd start'
gpssh -h smdw -e 'sed -i 's/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h smdw -e 'sed -i 's/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h smdw -e 'sed -i 's/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf'
gpssh -h smdw -e 'echo "server mdw prefer" >> /etc/ntp.conf'
gpssh -h smdw -e 'echo "server 192.168.2.12" >> /etc/ntp.conf'
gpssh -h smdw -e '/etc/init.d/ntpd start'
cd /rawdata
gpcheck -h mdw
echo deadline > /sys/block/sr0/queue/scheduler
/sbin/blockdev --setra 16385 /dev/sda1
gpcheck -h mdw
echo "mdw" > hosts_gpcheck
echo "smdw" >> hosts_gpcheck
echo "sdw1" >> hosts_gpcheck
echo "sdw2" >> hosts_gpcheck
chmod 777 hosts_gpcheck
gpcheck -f hosts_gpcheck
echo "mdw" > host_file
echo "smdw" >> host_file
echo "sdw1" >> host_file
echo "sdw2" >> host_file
chmod 777 host_file
source /usr/local/greenplum-db-4.2.6.1/greenplum_path.sh
gpssh -f hostfile_exkeys -e 'service iptables save'
gpssh -f hostfile_exkeys -e 'service iptables stop'
gpssh -f hostfile_exkeys -e 'chkconfig iptables off'
source /usr/local/greenplum-db-4.2.6.1/greenplum_path.sh
gpcheckperf -f host_file -d /data -D
mkdir /home/gpadmin/gpconfigs
cp /usr/local/greenplum-db/docs/cli_help/gpconfigs/gpinitsystem_config /home/gpadmin/gpconfigs/gpinitsystem_config
cd /home/gpadmin/gpconfigs
echo "sdw1" > hostfile_gpinitsystem
echo "sdw2" >> hostfile_gpinitsystem
chmod 777 /home/gpadmin/gpconfigs/*
chmod 777 /home/gpadmin/gpconfigs
sed -i 's/\declare -a DATA_DIRECTORY=(\/data1\/primary \/data1\/primary \/data1\/primary \/data2\/primary \/data2\/primary \/data2\/primary)/declare -a DATA_DIRECTORY=(\/data\/primary)/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#MIRROR_PORT_BASE=50000/MIRROR_PORT_BASE=50000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#REPLICATION_PORT_BASE=41000/REPLICATION_PORT_BASE=41000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#MIRROR_REPLICATION_PORT_BASE=51000/MIRROR_REPLICATION_PORT_BASE=51000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#declare -a MIRROR_DATA_DIRECTORY=(\/data1\/mirror \/data1\/mirror \/data1\/mirror \/data2\/mirror \/data2\/mirror \/data2\/mirror)/declare -a MIRROR_DATA_DIRECTORY=(\/data\/mirror)/g' /home/gpadmin/gpconfigs/gpinitsystem_config
cp /var/local/.bash_profile /home/gpadmin/

source /home/gpadmin/.bash_profile 
scp /home/gpadmin/.bash_profile smdw:/home/gpadmin/





