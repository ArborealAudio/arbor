#ifndef DSP_H
#define DSP_H

#include "../cbase/cbase.h"
#include <math.h>
#include <strings.h>

#define PI M_PI
#define TWO_PI (2 * PI)
#define EULER M_E
#define SQRT1_2 M_SQRT1_2

static inline f64 db2lin(double db) {
    return pow(10.0, db / 20.0);
}

static inline f64 lin2db(double x) {
    return 20.0 * log(x);
}

typedef enum {
    Filter_Lowpass,
    Filter_Highpass,
    Filter_Bandpass,
    Filter_FirstOrderLowpass,
    Filter_FirstOrderHighpass,
    Filter_FirstOrderLowshelf,
    Filter_FirstOrderHighshelf,
    Filter_Type_Count,
} FilterType;

/*
    The preferred way to init a Filter is to use designated initializers, like so:
        Filter f = (Filter){
            .type = Filter_Lowpass,
            .cutoff = 812,
            .reso = SQRT1_2
        };
*/
typedef struct {
    FilterType type;
    f32 a1, a2, b0, b1, b2;
    f32 cutoff;
    f32 reso;
    f32 gain;
    f32 xn[2];
    f32 yn[2];
    f64 sample_rate;
} Filter;

static void filter_reset(Filter *f);
static void filter_set_coeffs(Filter *f);
static void filter_set_cutoff(Filter *f, f32 cutoff);
static void filter_set_reso(Filter *f, f32 reso);
static void filter_set_type(Filter *f, FilterType type);
static void filter_set_sample_rate(Filter *f, f64 sample_rate);
static f32 filter_process_sample(Filter *f, f32 sample);
static void filter_process(Filter *f, const f32 *in, f32 *out, u32 num_frames);

#endif
