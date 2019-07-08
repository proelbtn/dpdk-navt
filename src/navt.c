#include "navt.h"

#include <stdint.h>
#include <rte_mbuf.h>

typedef uint8_t bool;

#define true 1
#define false 0

uint16_t translation_int2ext(struct rte_mbuf *pkts[], uint16_t nb_pkts) {
    bool is_valid;
    uint16_t processed = 0;

    for (uint16_t i = 0; i < nb_pkts; i++) {
        is_valid = true;

        if (is_valid) {
            pkts[processed] = pkts[i];
            processed++;
        }
        else rte_pktmbuf_free(pkts[i]);
    }

    return processed;
}

uint16_t translation_ext2int(struct rte_mbuf *pkts[], uint16_t nb_pkts) {
    bool is_valid;
    uint16_t processed = 0;

    for (uint16_t i = 0; i < nb_pkts; i++) {
        is_valid = true;

        if (is_valid) {
            pkts[processed] = pkts[i];
            processed++;
        }
        else rte_pktmbuf_free(pkts[i]);
    }

    return processed;
}