# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "dpdk" do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8192
    end
    config.vm.network "private_network", ip: "172.16.0.101"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-1"
    config.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-2"
  end
end
