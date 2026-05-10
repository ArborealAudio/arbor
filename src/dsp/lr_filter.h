// Fake Linkwitz-Riley filter implementation, created by cascading two 2nd-order biquad IIRs
// TODO Implement a real LR filter, perhaps by cascading two 2nd-order Butterworth filters

typedef struct {
    f32 cutoff;
    f64 sample_rate;
    IIR_Filter lp[2];
    IIR_Filter hp[2];
} LR_Filter;

void lr_filter_init(LR_Filter *f);
void lr_filter_update(LR_Filter *f);
void lr_filter_set_sample_rate(LR_Filter *f, f64 sample_rate);
void lr_filter_set_cutoff(LR_Filter *f, f64 cutoff);
void lr_filter_process_sample(LR_Filter *f, f64 in, f64 *out_low, f64 *out_high);
