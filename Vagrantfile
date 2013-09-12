Vagrant.configure("2") do |config|
  config.vm.box = "centos-64-x64-vbox4210-nocm.box"
  
  config.vm.provider :virtualbox do |v, override|
    override.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end
   config.vm.synced_folder "remote", "/var/local"
  
  config.vm.define :smdw do |smdw_config|
    smdw_config.vm.network :private_network, ip: "192.168.2.12"
    smdw_config.vm.hostname = "smdw"
	smdw_config.vm.provision :shell, :path => "salve.sh"
  end
  
  config.vm.define :sdw1 do |sdw1_config|
    sdw1_config.vm.network :private_network, ip: "192.168.2.13"
    sdw1_config.vm.hostname = "sdw1"
	sdw1_config.vm.provision :shell, :path => "salve.sh"
  end
  
 config.vm.define :sdw2 do |sdw2_config|
    sdw2_config.vm.network :private_network, ip: "192.168.2.14"
    sdw2_config.vm.hostname = "sdw2"
	sdw2_config.vm.provision :shell, :path => "salve.sh"
  end


    config.vm.define :mdw do |mdw_config|
    mdw_config.vm.network :private_network, ip: "192.168.2.11"
    mdw_config.vm.hostname = "mdw"
	mdw_config.vm.provision :shell, :path => "master.sh"
	mdw_config.vm.provision :shell, :path => "gp.sh"
	mdw_config.vm.provision :shell, :path => "gpInstall.sh"
  end
 
end
