Prerequisites for installation Greenplum Vagrant
------------------
------------------
1. Install Virtualbox from https://www.virtualbox.org/wiki/Download_Old_Builds_5_0
2. Install latest version of Vagrant from https://www.vagrantup.com/downloads.html


Installation of Greenplum
--------------
--------------
Enter following commands in your terminal window
```
$ git clone https://github.com/kailashjoshi/greenplum.git
$ cd greenplum
$ vagrant up
```
Once the vagrant installtion process is completed, follow these steps from your terminal window
```
$ vagrant ssh mdw
$ su - gpadmin
$ Enter the password. The password is "changeme"
$ source /home/gpadmin/.bash_profile 
$ gpinitsystem -c /home/gpadmin/gpconfigs/gpinitsystem_config -h /home/gpadmin/gpconfigs/hostfile_gpinitsystem -s smdw -S
```
Installation is completed!!

Test the installation
--------------
--------------
1. Run "gpstate" from your terminal window

If you see no error when running gpstate, that means Greenplum has been sucessfully completed.

## Using a sample database ##

You may also wish to experiment with a sample database. If you are **not** currently logged into the mdw machine as
gpadmin, make sure to log in there first (same as above steps)

> 1. vagrant ssh mdw
> 2. su - gpadmin
> 3. Enter the password. The password is "changeme"

As user gpadmin on mdw...
```
$ createdb world
$ psql -d world -a -f /var/local/world.sql
$ psql world
> select * from city limit 10; 
```






