#!/bin/sh

mkdir -p /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
echo 128 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
