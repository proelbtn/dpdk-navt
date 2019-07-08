# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "EXT" do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |v|
      v.cpus = 1
      v.memory = 1024
    end

    config.vm.network "private_network", ip: "172.16.0.101"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-1"

    config.vm.synced_folder ".", "/host"
    config.vm.provision "shell", path: "./scripts/provision-tests.sh"
  end
end

Vagrant.configure("2") do |config|
  config.vm.define "INT" do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |v|
      v.cpus = 1
      v.memory = 1024
    end

    config.vm.network "private_network", ip: "172.16.0.101"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-2"

    config.vm.synced_folder ".", "/host"
    config.vm.provision "shell", path: "./scripts/provision-tests.sh"
  end
end

Vagrant.configure("2") do |config|
  config.vm.define "DPDK" do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8192
    end

    config.vm.network "private_network", ip: "172.16.0.101"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-1"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-2"

    config.vm.synced_folder ".", "/host"
    config.vm.provision "shell", path: "./scripts/provision-dpdk.sh"
  end
end
