import sys
from scapy.all import *

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage:\n  main.py [device name]")

    dev = sys.argv[1]

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= IP(src="172.31.50.1", dst="10.1.0.1")
    pkt /= TCP(sport=22, dport=12345)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= IP(src="172.31.50.1", dst="10.2.0.1")
    pkt /= TCP(sport=22, dport=12345)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= IP(src="172.31.50.1", dst="10.1.0.1")
    pkt /= UDP(sport=22, dport=12345)
    sendp(pkt, iface=dev)

    pkt = Ether(dst="02:00:00:00:00:01", src="02:00:00:00:00:ff")
    pkt /= IP(src="172.31.50.1", dst="10.2.0.1")
    pkt /= UDP(sport=22, dport=12345)
    sendp(pkt, iface=dev)
