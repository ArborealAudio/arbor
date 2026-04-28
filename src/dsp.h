#ifndef DSP_H
#define DSP_H

#include "../cbase/cbase.h"
#include <math.h>

#define PI M_PI
#define TWO_PI (2 * PI)
#define EULER M_E
#define SQRT1_2 M_SQRT1_2

static inline f64 db2lin(f64 db) {
    return pow(10.0, db / 20.0);
}

static inline f64 lin2db(f64 x) {
    return 20.0 * log(x);
}

static inline f32 db2linf(f32 db) {
    return powf(10.f, db / 20.f);
}

static inline f32 lin2dbf(f32 x) {
    return 20.f * logf(x);
}

//
// IIR FILTER
//

typedef enum {
    IIR_Filter_Lowpass,
    IIR_Filter_Highpass,
    IIR_Filter_Bandpass,
    IIR_Filter_FirstOrderLowpass,
    IIR_Filter_FirstOrderHighpass,
    IIR_Filter_FirstOrderLowshelf,
    IIR_Filter_FirstOrderHighshelf,
    IIR_Filter_Type_Count,
} IIR_FilterType;

/*
    The preferred way to init a Filter is to use designated initializers, like so:
        Filter f = (Filter){
            .type = Filter_Lowpass,
            .cutoff = 812,
            .reso = SQRT1_2
        };
*/
typedef struct {
    IIR_FilterType type;
    f32 a1, a2, b0, b1, b2;
    f32 cutoff;
    f32 reso;
    f32 gain;
    f32 xn[2];
    f32 yn[2];
    f64 sample_rate;
} IIR_Filter;

static void filter_reset(IIR_Filter *f);
static void filter_set_coeffs(IIR_Filter *f);
static void filter_set_cutoff(IIR_Filter *f, f32 cutoff);
static void filter_set_reso(IIR_Filter *f, f32 reso);
static void filter_set_type(IIR_Filter *f, IIR_FilterType type);
static void filter_set_sample_rate(IIR_Filter *f, f64 sample_rate);
static f32 filter_process_sample(IIR_Filter *f, f32 sample);
static void filter_process(IIR_Filter *f, const f32 *in, f32 *out, u32 num_frames);

#endif
