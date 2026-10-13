#include "lr_filter.h"

const float _tpt_butterworth_q = SQRT1_2;
const float _tpt_k = SQRT2;

static void _tpt_init(TPTFilter *f, f32 cutoff, f64 sample_rate) {
    float g = tanf(PI * cutoff / sample_rate);
    f->a1 = 1.f / (1.f + g * (g + _tpt_k));
    f->a2 = g * f->a1;
    f->a3 = g * f->a2;

    f->s1 = f->s2 = 0;
}

void lr_filter_init(LR_Filter *f, f32 cutoff, f64 sample_rate) {
    f->cutoff = cutoff;
    f->sample_rate = sample_rate;
    _tpt_init(&f->stage[0], cutoff, sample_rate);
    _tpt_init(&f->stage[1], cutoff, sample_rate);
    _tpt_init(&f->stage[2], cutoff, sample_rate);
}

void lr_filter_set_cutoff(LR_Filter *f, f32 cutoff) {
    lr_filter_init(f, cutoff, f->sample_rate);
}

static void _tpt_filter_process_sample_2out(TPTFilter *f, f64 x, f64 *low, f64 *hi) {
    f64 y = x - f->s2;
    f64 y2 = f->a1 * f->s1 + f->a2 * y;
    f64 y3 = f->s2 + f->a2 * f->s1 + f->a3 * y;

    f->s1 = 2.0 * y2 - f->s1;
    f->s2 = 2.0 * y3 - f->s2;

    *low = y3;
    *hi = x - _tpt_k * y2 - y3;
}

static f64 _tpt_filter_process_sample(TPTFilter *f, f64 x, bool32 highpass) {
    f64 y = x - f->s2;
    f64 y2 = f->a1 * f->s1 + f->a2 * y;
    f64 y3 = f->s2 + f->a2 * f->s1 + f->a3 * y;

    f->s1 = 2.0 * y2 - f->s1;
    f->s2 = 2.0 * y3 - f->s2;

    return highpass ? x - _tpt_k * y2 - y3 : y3;
}

void lr_filter_process_sample(LR_Filter *f, f64 in, f64 *low, f64 *high) {
    f64 yl, yh;
    yl = yh = in;
    _tpt_filter_process_sample_2out(&f->stage[0], in, &yl, &yh);
    *low = _tpt_filter_process_sample(&f->stage[1], yl, FALSE);
    *high = _tpt_filter_process_sample(&f->stage[2], yh, TRUE);
}
