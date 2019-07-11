#!/bin/sh

set +x

# 1. enable transition
sudo sysctl net.ipv4.ip_forward=1

# 2. create a net namespace
sudo ip netns add NOC

# 3. create a virtual network device
sudo ip link add NOC-ERT type veth peer name ERT-NOC

# 4. move virtual network into net namespaces
sudo ip link set NOC-ERT netns NOC

# 5. settings for NOC
sudo ip netns exec NOC sh <<EOF
sudo ip addr add 172.31.50.1/24 dev NOC-ERT
sudo ip link set NOC-ERT up
sudo ip route add default via 172.31.50.254
EOF

# 6. settings for ERT
sudo ip link set addr 02:00:00:00:00:ff dev enp0s8  # enp0s8 == ERT-NAVT
sudo ip addr add 172.31.50.254/24 dev ERT-NOC
sudo ip link set ERT-NOC up
sudo ip neigh add 172.26.0.1 lladdr 02:00:00:00:00:01 dev enp0s8
sudo ip neigh add 172.26.0.2 lladdr 02:00:00:00:00:02 dev enp0s8
sudo ip route add 10.1.0.0/16 via 172.26.0.1
sudo ip route add 10.2.0.0/16 via 172.26.0.2

sudo ip link set enp0s8 promisc on

# sudo ip netns exec noc bash
#   ping 10.1.0.1
#   ping 10.2.0.1
