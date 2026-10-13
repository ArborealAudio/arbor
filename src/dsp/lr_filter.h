#ifndef LR_FILTER_H
#define LR_FILTER_H

// Linkwitz-Riley filter, providing a 24 db/oct filter cutoff with flat amplitude response
// at the cutoff when high and low bands are summed together

#include "dsp.h"

typedef struct {
    f32 a1, a2, a3;
    f32 s1, s2;
} TPTFilter;

typedef struct {
    f32 cutoff;
    f64 sample_rate;
    TPTFilter stage[3];
} LR_Filter;

void lr_filter_init(LR_Filter *f, f32 cutoff, f64 sample_rate);
void lr_filter_set_cutoff(LR_Filter *f, f32 cutoff);
void lr_filter_update(LR_Filter *f);
void lr_filter_process_sample(LR_Filter *f, f64 in, f64 *out_low, f64 *out_high);

#endif
