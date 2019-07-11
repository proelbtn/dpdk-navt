#!/bin/sh

set +x

# 1. delete an unnessesary IP address
sudo ip addr del 172.26.0.1/24 dev enp0s8

# 2. enable transition
sudo sysctl net.ipv4.ip_forward=1

# 3. create net namespaces
sudo ip netns add teamA-GWR
sudo ip netns add teamA-Client
sudo ip netns add teamB-GWR
sudo ip netns add teamB-Client

# 4. create virtual network devices
sudo ip link add link enp0s8 name AG-IRT type vlan id 100  # enp0s8 == IRT-NAVT
sudo ip link add link enp0s8 name BG-IRT type vlan id 200
sudo ip link add AG-AC type veth peer name AC-AG
sudo ip link add BG-BC type veth peer name BC-BG

# 5. move virtual network into net namespaces
sudo ip link set AG-IRT netns teamA-GWR
sudo ip link set BG-IRT netns teamB-GWR
sudo ip link set AG-AC netns teamA-GWR
sudo ip link set AC-AG netns teamA-Client
sudo ip link set BG-BC netns teamB-GWR
sudo ip link set BC-BG netns teamB-Client

# 6. settings for teamA-GWR
sudo ip netns exec teamA-GWR sh <<EOF
ip link set addr 02:00:00:00:00:01 dev AG-IRT
ip addr add 172.26.0.1/24 dev AG-IRT
ip addr add 192.168.0.254/24 dev AG-AC

ip link set AG-IRT up
ip link set AG-AC up

ip neigh add 172.26.0.254 lladdr 02:00:00:00:00:ff dev AG-IRT
ip route add default via 172.26.0.254
EOF

# 6. settings for teamB-GWR
sudo ip netns exec teamB-GWR sh <<EOF
ip link set addr 02:00:00:00:00:02 dev BG-IRT
ip addr add 172.26.0.1/24 dev BG-IRT
ip addr add 192.168.0.254/24 dev BG-BC 

ip link set BG-IRT up
ip link set BG-BC up

ip neigh add 172.26.0.254 lladdr 02:00:00:00:00:ff dev BG-IRT
ip route add default via 172.26.0.254
EOF

# 6. settings for teamA-Client
sudo ip netns exec teamA-Client sh <<EOF
ip addr add 192.168.0.1/24 dev AC-AG
ip link set AC-AG up
ip route add default via 192.168.0.254
EOF

# 6. settings for teamB-Client
sudo ip netns exec teamB-Client sh <<EOF
ip addr add 192.168.0.1/24 dev BC-BG
ip link set BC-BG up
ip route add default via 192.168.0.254
EOF

# enable promiscuous mode
sudo ip link set enp0s8 promisc on
