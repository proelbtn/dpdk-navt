#pragma once

#include <stdint.h>
#include <rte_mbuf.h>

enum translation_mode_t {
    NAVT_INT2EXT = 0,
    NAVT_EXT2INT = 1,
};

uint16_t translation(struct rte_mbuf *pkts[], uint16_t nb_pkts, enum translation_mode_t type);