#!/bin/sh

apt update
apt install -y build-essential libelf-dev libnuma-dev libpcap-dev pkg-config

wget http://fast.dpdk.org/rel/dpdk-19.05.tar.xz
tar xfv dpdk-19.05.tar.xz

cd dpdk-19.05

make config T=x86_64-native-linux-gcc
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config

make -j4

