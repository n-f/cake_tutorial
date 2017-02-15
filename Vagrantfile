# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Vagrant insecure key detected. Vagrant will automatically replace の状態を止める
  config.ssh.insert_key = false

  #sshする際に、-Aオプションを付けずに、githubの鍵などをvagrantに持っていけるようにする
  config.ssh.forward_agent = true

  config.vm.box = "bento/centos-7.2"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision "shell",:path => "./provision.sh"

  #httpdを起動する
 # config.vm.provision "shell", run: "always", :inline => "systemctl start httpd"
end
