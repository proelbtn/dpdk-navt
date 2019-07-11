import sys
from scapy.all import *

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage:\n  main.py [device name]")

    dev = sys.argv[1]

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= Dot1Q(vlan=100)
    pkt /= IP(src="192.168.0.1", dst="172.31.50.1")
    pkt /= TCP(sport=12345, dport=22)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= Dot1Q(vlan=200)
    pkt /= IP(src="192.168.0.1", dst="172.31.50.1")
    pkt /= TCP(sport=12345, dport=22)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= Dot1Q(vlan=100)
    pkt /= IP(src="192.168.0.1", dst="172.31.50.1")
    pkt /= UDP(sport=12345, dport=22)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= Dot1Q(vlan=200)
    pkt /= IP(src="192.168.0.1", dst="172.31.50.1")
    pkt /= UDP(sport=12345, dport=22)
    sendp(pkt, iface=dev)
