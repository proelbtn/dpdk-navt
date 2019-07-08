#pragma once

#include <stdint.h>
#include <rte_mbuf.h>

uint16_t translation_int2ext(struct rte_mbuf *pkts[], uint16_t nb_pkts);
uint16_t translation_ext2int(struct rte_mbuf *pkts[], uint16_t nb_pkts);