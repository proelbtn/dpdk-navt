#include "navt.h"

#include <stdint.h>
#include <rte_mbuf.h>
#include <rte_ether.h>
#include <rte_ip.h>
#include <rte_tcp.h>
#include <rte_udp.h>

typedef uint8_t bool;

#define true 1
#define false 0

static bool translation_int2ext(struct rte_mbuf *pkt) {
    struct ether_hdr *ehdr;
    struct ipv4_hdr *ihdr;
    struct tcp_hdr *thdr;
    struct udp_hdr *uhdr;

    // 1. strip vlan header
    if (rte_vlan_strip(pkt) != 0) return false;

    // 2. calculate teamid
    //   when rte_vlan_strip applied, vlan id is stored pkt->vlan_tci.
    //   refs: http://doc.dpdk.org/api/rte__ether_8h_source.html
    uint16_t teamid = pkt->vlan_tci / 100;
    if (!(1 <= teamid && teamid <= 16)) return false;

    // 3. translate ip address
    ehdr = rte_pktmbuf_mtod(pkt, struct ether_hdr *);
    ihdr = (struct ipv4_hdr *)(ehdr + 1);

    uint32_t saddr = rte_be_to_cpu_32(ihdr->src_addr);
    if ((saddr & 0xffff0000) != IPv4(192, 168, 0, 0)) return false;
    saddr = IPv4(10, teamid, 0, 0) | (saddr & ~0xffff0000);
    ihdr->src_addr = rte_cpu_to_be_32(saddr);

    // 4. clear checksum in ipv4_hdr
    ihdr->hdr_checksum = 0;

    // 5. recalculate checksum in l4_hdr
    switch (ihdr->next_proto_id) {
        case IPPROTO_ICMP:
            break;
        case IPPROTO_TCP:
            thdr = (struct tcp_hdr *)((char *)ihdr + sizeof(struct ipv4_hdr));
            thdr->cksum = 0;
            thdr->cksum = rte_ipv4_udptcp_cksum(ihdr, thdr);
            break;
        case IPPROTO_UDP:
            uhdr = (struct udp_hdr *)((char *)ihdr + sizeof(struct ipv4_hdr));
            uhdr->dgram_cksum = 0;
            uhdr->dgram_cksum = rte_ipv4_udptcp_cksum(ihdr, uhdr);
            break;
        default:
            // if ihdr->next_proto_id isn't expected value, the packet will be drop
            return false;
    }

    // 6. recalculate checksum in ipv4_hdr
    ihdr->hdr_checksum = rte_ipv4_cksum(ihdr);

    return true;
}

static bool translation_ext2int(struct rte_mbuf *pkt) {
    return true;
}

uint16_t translation(struct rte_mbuf *pkts[], uint16_t nb_pkts, enum translation_mode_t type) {
    bool is_valid;
    uint16_t processed = 0;

    for (uint16_t i = 0; i < nb_pkts; i++) {
        switch (type) {
            case NAVT_INT2EXT:
                is_valid = translation_int2ext(pkts[i]);
                break;
            case NAVT_EXT2INT:
                is_valid = translation_ext2int(pkts[i]);
                break;
            default:
                is_valid = false;
        }

        if (is_valid) {
            pkts[processed] = pkts[i];
            processed++;
        }
        else rte_pktmbuf_free(pkts[i]);
    }

    return processed;
}
