#include "dsp.h"

static void filter_reset(IIR_Filter *f) {
    f->xn[0] = f->xn[1] = f->yn[0] = f->yn[1] = 0;
}

static void filter_set_coeffs(IIR_Filter *f) {
    if (f->type < IIR_Filter_FirstOrderLowpass && f->reso == 0) {
        err("2nd-order Filter cannot have reso of 0\n");
        f->reso = SQRT1_2;
    }
    const f64 sr = f->sample_rate;
    const f64 w0 = TWO_PI * (f->cutoff / sr);
    const f64 q = 1.0 / (2.0 * f->reso);
    const f64 tmp = exp(-q * w0);
    f->a1 = -2.0 * tmp;
    if (q <= 1.0) {
        f->a1 *= cos(sqrt(1.0 - q * q) * w0);
    } else {
        f->a1 *= cosh(sqrt(q * q - 1.0) * w0);
    }
    f->a2 = tmp * tmp;

    const f64 f0 = f->cutoff / (sr * 0.5);
    const f64 freq2 = f0 * f0;
    const f64 reso2 = f->reso * f->reso;
    const f64 fac = (1.0 - freq2) * (1.0 - freq2);

    switch (f->type) {
    case IIR_Filter_Lowpass: {
        const f64 r0 = 1.0 + f->a1 + f->a2;
        const f64 r1_num = (1.0 - f->a1 + f->a2) * freq2;
        const f64 r1_denom = sqrt(fac + freq2 / reso2);
        const f64 r1 = r1_num / r1_denom;
        f->b0 = (r0 + r1) / 2.0;
        f->b1 = r0 - f->b0;
        f->b2 = 0;
    } break;
    case IIR_Filter_Highpass: {
        const f64 r1_num = 1.0 - f->a1 + f->a2;
        const f64 r1_denom = sqrt(fac + freq2 / (reso2));
        const f64 r1 = r1_num / r1_denom;

        f->b0 = r1 / 4.0;
        f->b1 = -2.0 * f->b0;
        f->b2 = f->b0;
    } break;
    case IIR_Filter_Bandpass: {
        const f64 r0 = (1.0 + f->a1 + f->a2) / (PI * f0 * f->reso);
        const f64 r1_num = (1.0 - f->a1 + f->a2) * (f0 / f->reso);
        const f64 r1_denom = sqrt(fac + freq2 / reso2);
        const f64 r1 = r1_num / r1_denom;

        f->b1 = -r1 / 2.0;
        f->b0 = (r0 - f->b1) / 2.0;
        f->b2 = -f->b0 - f->b1;
    } break;
    case IIR_Filter_FirstOrderLowpass: {
        const f64 fc = f->cutoff / sr;
        f->a1 = -exp(-fc * TWO_PI);
        const f64 gain_nyq = sqrt(fc * fc / (0.25 + fc * fc));
        f->b0 = 0.5 * (gain_nyq * (1 - f->a1) + 1 + f->a1);
        f->b1 = 1 + f->a1 - f->b0;
        f->b2 = 0;
        f->a2 = 0;
    } break;
    case IIR_Filter_FirstOrderHighpass: {
        const f64 fc = f->cutoff / sr;
        f->a1 = exp(-fc * TWO_PI);
        const f64 gain_nyq = sqrt(0.25 / (0.25 + fc * fc));
        f->b0 = 0.5 * gain_nyq * (1 - f->a1);
        f->b1 = -f->b0;
        f->a2 = 0;
        f->b2 = 0;
    } break;
    case IIR_Filter_FirstOrderHighshelf: {
        const f64 pi_sqr_2 = 2.0 / (PI * PI);
        const f64 alpha = pi_sqr_2 * (1 + 1 / (f->gain * freq2)) - 0.5;
        const f64 beta = pi_sqr_2 * (1 + f->gain / freq2) - 0.5;
        f->a1 = -alpha / (1 + alpha + sqrt(1 + 2 * alpha));
        const f64 b = -beta / (1 + beta + sqrt(1 + 2 * beta));
        f->b0 = (1 + f->a1) / (1 + b);
        f->b1 = b * f->b0;
        f->a2 = 0;
        f->b2 = 0;
    } break;
    case IIR_Filter_FirstOrderLowshelf: {
        const f64 igain = 1 / f->gain;
        const f64 pi_sqr_2 = 2.0 / (PI * PI);
        const f64 alpha = pi_sqr_2 * (1 + 1 / (igain * freq2)) - 0.5;
        const f64 beta = pi_sqr_2 * (1 + igain / freq2) - 0.5;
        f->a1 = -alpha / (1 + alpha + sqrt(1 + 2 * alpha));
        const f64 b = -beta / (1 + beta + sqrt(1 + 2 * beta));
        f->b0 = f->gain * ((1 + f->a1) / (1 + b));
        f->b1 = b * f->b0;
        f->a2 = 0;
        f->b2 = 0;
    } break;
    default: break;
    }
}

static void filter_set_cutoff(IIR_Filter *f, f32 cutoff) {
    f->cutoff = cutoff;
    filter_set_coeffs(f);
}

static void filter_set_reso(IIR_Filter *f, f32 reso) {
    f->reso = reso;
    filter_set_coeffs(f);
}

static void filter_set_type(IIR_Filter *f, IIR_FilterType type) {
    f->type = type;
    filter_set_coeffs(f);
}

static void filter_set_sample_rate(IIR_Filter *f, f64 sample_rate) {
    f->sample_rate = sample_rate;
    filter_set_coeffs(f);
}

static f32 filter_process_sample(IIR_Filter *f, f32 sample) {
    f64 b = f->b0 * sample + f->b1 * f->xn[0] + f->b2 * f->xn[1];
    f64 a = -f->a1 * f->yn[0] - f->a2 * f->yn[1];
    f32 result = a + b;
    f->xn[1] = f->xn[0];
    f->xn[0] = sample;
    f->yn[1] = f->yn[0];
    f->yn[0] = result;
    return result;
}

static void filter_process(IIR_Filter *f, const f32 *in, f32 *out, u32 num_frames) {
    for (u32 i = 0; i < num_frames; ++i) {
        out[i] = filter_process_sample(f, in[i]);
    }
}
