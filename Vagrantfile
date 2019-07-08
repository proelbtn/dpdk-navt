# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |c|
  c.vm.define "EXT" do |c|
    c.vm.box = "ubuntu/bionic64"

    c.vm.provider "virtualbox" do |v|
      v.cpus = 1
      v.memory = 1024
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    end

    c.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-1"

    c.vm.synced_folder ".", "/host"
    c.vm.provision "shell", path: "./scripts/provision-tests.sh"
  end
end

Vagrant.configure("2") do |c|
  c.vm.define "INT" do |c|
    c.vm.box = "ubuntu/bionic64"

    c.vm.provider "virtualbox" do |v|
      v.cpus = 1
      v.memory = 1024
      v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    end

    c.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-2"

    c.vm.synced_folder ".", "/host"
    c.vm.provision "shell", path: "./scripts/provision-tests.sh"
  end
end

Vagrant.configure("2") do |c|
  c.vm.define "DPDK" do |c|
    c.vm.box = "ubuntu/bionic64"

    c.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8192
    end

    c.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-1", nic_type: "virtio"
    c.vm.network "private_network", ip: nil, virtualbox__intnet: "dpdk-int-2", nic_type: "virtio"

    c.vm.synced_folder ".", "/host"
    c.vm.provision "shell", path: "./scripts/provision-dpdk.sh"
  end
end
