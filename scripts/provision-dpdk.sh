#!/bin/sh

mv /tmp/authorized_keys /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

apt update
apt install -y build-essential libnuma-dev libpcap-dev

wget http://fast.dpdk.org/rel/dpdk-19.05.tar.xz
tar xfv dpdk-19.05.tar.xz

cd dpdk-19.05

make config T=x86_64-native-linux-gcc
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config

make -j4

