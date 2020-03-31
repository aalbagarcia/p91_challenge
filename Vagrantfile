# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	do_token        = ENV.fetch('DO_TOKEN'){'token'}
	do_ssh_key_name = ENV.fetch('DO_SSH_KEY_NAME'){'ssh-key-name'}
	do_ssh_key_path = ENV.fetch('DO_SSH_KEY_PATH'){'~/.ssh/id_rsa'}

	#hostmanager plugin configuration
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false
	# END

  config.vm.box   = "base"

	config.vm.synced_folder ".", "/vagrant", disabled: true

  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

	config.ssh.private_key_path = do_ssh_key_path

  config.vm.define "db-droplet" do |config|
    config.vm.provider :digital_ocean do |provider, override|
      provider.token = do_token
      provider.image = 'ubuntu-19-10-x64'
      provider.region = 'ams3'
      provider.size = '512mb'
      provider.backups_enabled = false
      provider.private_networking = true
      provider.ipv6 = false
      provider.monitoring = true
			provider.ssh_key_name = do_ssh_key_name
		end
    # We use shell provisioning here.
    # TODO: replace shell provisioning with ansible
    config.vm.provision "shell", path: './vagrant_scripts/db-droplet.sh'

  end

  config.vm.define "core-droplet" do |config|
    config.vm.provider :digital_ocean do |provider, override|
      provider.token = do_token
      provider.image = 'ubuntu-19-10-x64'
      provider.region = 'ams3'
      provider.size = '512mb'
      provider.backups_enabled = false
      provider.private_networking = true
      provider.ipv6 = false
      provider.monitoring = true
      provider.ssh_key_name = do_ssh_key_name
    end
	end


  config.vm.define "jenkins-droplet" do |config|
    config.vm.provider :digital_ocean do |provider, override|
      provider.token = do_token
			#provider.image = 'jenkins-18-04'
			provider.image = 'ubuntu-19-10-x64'
      provider.region = 'ams3'
      provider.size = '1gb'
      provider.backups_enabled = false
      provider.private_networking = true
      provider.ipv6 = false
      provider.monitoring = true
      provider.ssh_key_name = do_ssh_key_name
		end

		# We use shell provisioning here.
		# TODO: replace shell provisioning with ansible
		config.vm.provision "shell", path: './vagrant_scripts/jenkins-droplet.sh'
  end
end
