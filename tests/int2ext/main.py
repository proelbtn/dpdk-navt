import sys
from scapy.all import *

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage:\n  main.py [device name]")

    dev = sys.argv[1]

    pkt = Ether()
    pkt /= ARP(op=1, pdst="172.26.0.254")
    sendp(pkt, iface=dev)

    pkt = Ether()
    pkt /= IP(dst="172.26.0.254")
    pkt /= ICMP()
    sendp(pkt, iface=dev)
