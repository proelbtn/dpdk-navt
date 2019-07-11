#!/bin/sh

apt update
apt install -y python3-scapy

ip link set enp0s8 promisc on
