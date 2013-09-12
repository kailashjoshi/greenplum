Prerequisites for installation Greenplum Vagrant
------------------
------------------
1. Install Vmbox from https://www.virtualbox.org/wiki/Downloads
2. Install latest version of Vagrant from http://downloads.vagrantup.com/


Installation of Greenplum
--------------
--------------

1. mkdir greenplum
2. cd greenplum
3. git init
4. git clone https://github.com/kailashjoshi/greenplum.git
5. vagrant up

Once the vagrant installtion process is completed, follow these steps from your terminal window

1. vagrant ssh mdw
2. su - gpadmin
3. Enter the password. The password is "changeme"
4. source /home/gpadmin/.bash_profile 
5. gpinitsystem -c /home/gpadmin/gpconfigs/gpinitsystem_config -h /home/gpadmin/gpconfigs/hostfile_gpinitsystem -s smdw -S

Installation is completed!!

Test the installation
--------------
--------------
1. Run "gpstate" from your terminal window

If you see no error when running gpstate, that means Greenplum has been sucessfully completed.

Thanks you!




