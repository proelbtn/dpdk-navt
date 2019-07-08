import sys
from scapy.all import *

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage:\n  main.py [device name]")

    dev = sys.argv[1]

    pkt = Ether(dst="ff:ff:ff:ff:ff:ff", src="20:00:00:00:00:11")
    pkt /= ARP(op=1, hwsrc="20:00:00:00:00:11", psrc="172.26.0.1", pdst="172.26.0.254")

    sendp(pkt, iface=dev)
