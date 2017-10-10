# -*- mode: ruby -*-
# vi: set ft=ruby :
#

HOST_NAME = "packstack-1"
MANIFEST = "#{HOST_NAME}"
CPUS = "2"
MEMORY = "6144"
ENVIRONMENT = "development"
#PUPPET = "4.8.2"
VAGRANTDIR = File.expand_path(File.dirname(__FILE__))
VAGRANTFILE_API_VERSION = "2"
#DATADIR = "#{VAGRANTDIR}/puppetlabs/code/environments/#{ENVIRONMENT}/data"

# Load the required vagrant pluging.
## ref http://matthewcooper.net/2015/01/15/automatically-installing-vagrant-plugin-dependencies/
required_plugins = %w( vagrant-vbguest vagrant-puppet-install vagrant-r10k vagrant-scp vagrant-share  )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

# Link to the puppet environments data directory so we don't have 
# to go digging around for it.
##unless FileTest.symlink?("#{VAGRANTDIR}/puppetlabs/data")
##  File.symlink "#{DATADIR}", "#{VAGRANTDIR}/puppetlabs/data"
##end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Disable insecure key replacement
  config.ssh.insert_key = false
  # Use your id_rsa key from !/.ssh
  config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
  #config.vm.box = "centos/7"
  config.vm.box = "flannon/packstack"

  config.vm.network "private_network", type: "dhcp",
    virtualbox__hostonly: true
  #config.vm.network "private_network", type: "dhcp",
  #  virtualbox__hostonly: true
  config.vm.network "forwarded_port", guest:  80, host: 4080 #,
  config.vm.network "forwarded_port", guest:  443, host: 4443 #,
  #config.vm.network "private_network", ip: "192.168.50.39",
      #virtualbox__hostonly: true
  config.vm.network "private_network", ip: "172.16.0.10"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    # ref for multiple cpu support
    # https://github.com/rdsubhas/vagrant-faster/issues/5
    vb.cpus = CPUS
    if CPUS != "1"
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    vb.memory = MEMORY
    vb.name = HOST_NAME
    vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
    vb.customize ["modifyvm", :id, "--nic3", "natnetwork", "--nat-network3", "packstack"]
  end
  
  config.vm.hostname = HOST_NAME + ".local"
  config.vm.synced_folder "./", "/vagrant", create: true

  #config.vm.provision "shell", path: "bin/init-puppet-centos7.sh"
  config.vm.provision "shell", path: "bin/init-selinux.sh"
  config.vm.provision "shell", path: "bin/init-grub.sh"
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  config.vm.provision "shell", inline: "sleep 20"
  config.vm.provision :reload
  config.vm.provision "shell", inline: "sleep 5"

  #config.r10k.puppet_dir = "puppetlabs/code/environments/#{ENVIRONMENT}"
  #config.r10k.puppetfile_path = "puppetlabs/code/environments/#{ENVIRONMENT}/Puppetfile"
  #config.r10k.module_path = "puppetlabs/code/environments/#{ENVIRONMENT}/modules/thirdparty"

  # Plugin to force vagrant to use a spcecific version of puppet
  #config.puppet_install.puppet_version = "#{PUPPET}"
  #config.vm.provision "puppet" do |puppet|
  #    puppet.hiera_config_path = 'puppetlabs/puppet/hiera.yaml'
  #    #puppet.hiera_config_path = 'puppetlabs/code/environments/development//hiera.yaml'
  #    puppet.environment_path = "puppetlabs/code/environments"
  #    puppet.environment = "#{ENVIRONMENT}"
  #    puppet.manifests_path = "puppetlabs/code/environments/#{ENVIRONMENT}/manifests"
  #    puppet.manifest_file = "#{MANIFEST}.pp"
  #    puppet.module_path = ["puppetlabs/code/modules/development", "puppetlabs/code/environments/#{ENVIRONMENT}/modules/site", "puppetlabs/code/environments/#{ENVIRONMENT}/modules/local", "puppetlabs/code/environments/#{ENVIRONMENT}/modules/thirdparty"]
  #    # Working directory needs to be set because vagrant does not
  #    # calculate path relative to the environment
  #    puppet.working_directory = "/tmp/vagrant-puppet/environments/#{ENVIRONMENT}"         
  #    puppet.options = [
  #                     "--verbose",
  #                     #"--debug",
  #                     "--trace",
  #                     "--strict_variables",
  #                     #"--hiera_config /vagrant/puppetlabs/puppet/hiera.yaml"
  #                     ] 
  #end
  #
  #config.vm.provision "shell", path: "bin/load-ssh-keys.sh"
  #config.vm.provision "shell", path: "bin/load-aws-credentials.sh"

end
