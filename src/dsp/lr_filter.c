
void lr_filter_init(LR_Filter *f) {
    for (int i = 0; i < 2; ++i) {
        f->lp[i].type = IIR_Filter_Lowpass;
        f->lp[i].cutoff = f->cutoff;
        f->hp[i].type = IIR_Filter_Highpass;
        f->hp[i].cutoff = f->cutoff;
    }
}

void lr_filter_update(LR_Filter *f) {
    // const f64 fc = f->cutoff;
    // const f64 wc = 2 * PI * fc;
    // const f64 wc2 = wc * wc;
    // const f64 wc3 = wc2 * wc;
    // const f64 wc4 = wc2 * wc2;
    // const f64 k = wc / tan(PI * fc / f->sample_rate);
    // const f64 k2 = k * k;
    // const f64 k3 = k2 * k;
    // const f64 k4 = k2 * k2;
    // const f64 sqrt2 = sqrt(2);
    // const f64 sq_tmp1 = sqrt2 * wc3 * k;
    // const f64 sq_tmp2 = sqrt2 * wc * k3;
    // const f64 a_tmp = 4 * wc2 * k2 + 2 * sq_tmp1 + k4 + 2 * sq_tmp2 + wc4;

    // f->b1 = (4 * (wc4 + sq_tmp1 - k4 - sq_tmp2)) / a_tmp;
    // f->b2 = (6 * wc4 - 8 * wc2 * k2 + 6 * k4) / a_tmp;
    // f->b3 = (4 * (wc4 - sq_tmp1 + sq_tmp2 - k4)) / a_tmp;
    // f->b4 = (k4 - 2 * sq_tmp1 + wc4 - 2 * sq_tmp2 + 4 * wc2 * k2) / a_tmp;

    // f->lp_a0 = wc4 / a_tmp;
    // f->lp_a1 = 4 * wc4 / a_tmp;
    // f->lp_a2 = 6 * wc4 / a_tmp;

    // f->hp_a0 = k4 / a_tmp;
    // f->hp_a1 = 4 * k4 / a_tmp;
    // f->hp_a2 = 6 * k4 / a_tmp;

    for (int i = 0; i < 2; ++i) {
        filter_set_coeffs(&f->lp[i]);
        filter_set_coeffs(&f->hp[i]);
    }
}

void lr_filter_set_sample_rate(LR_Filter *f, f64 sample_rate) {
    f->sample_rate = sample_rate;
    for (int i = 0; i < 2; ++i) {
        // f->lp[i].cutoff = f->cutoff;
        // f->hp[i].cutoff = f->cutoff;
        filter_set_sample_rate(&f->lp[i], sample_rate);
        filter_set_sample_rate(&f->hp[i], sample_rate);
    }
    // lr_filter_update(f);
}

void lr_filter_set_cutoff(LR_Filter *f, f64 cutoff) {
    f->cutoff = cutoff;
    for (int i = 0; i < 2; ++i) {
        filter_set_cutoff(&f->lp[i], f->cutoff);
        filter_set_cutoff(&f->hp[i], f->cutoff);
    }
    // lr_filter_update(f);
}

void lr_filter_process_sample(LR_Filter *f, f64 in, f64 *out_low, f64 *out_high) {
    // f64 yl = f->lp_a0 * in + f->lp_a1 * f->xn[0] + f->lp_a2 * f->xn[1] + f->lp_a1 * f->xn[2] + f->lp_a0 * f->xn[3] -
    //     f->b1 * f->ynl[0] - f->b2 * f->ynl[1] - f->b3 * f->ynl[2] - f->b4 * f->ynl[3];
    // f64 yh = f->hp_a0 * in + f->hp_a1 * f->xn[0] + f->hp_a2 * f->xn[1] + f->hp_a1 * f->xn[2] + f->hp_a0 * f->xn[3] -
    //     f->b1 * f->ynh[0] - f->b2 * f->ynh[1] - f->b3 * f->ynh[2] - f->b4 * f->ynh[3];
    // *out_low = yl;
    // *out_high = yh;
    // f->xn[3] = f->xn[2];
    // f->xn[2] = f->xn[1];
    // f->xn[1] = f->xn[0];
    // f->xn[0] = in;

    // f->ynl[3] = f->ynl[2];
    // f->ynl[2] = f->ynl[1];
    // f->ynl[1] = f->ynl[0];
    // f->ynl[0] = yl;

    // f->ynh[3] = f->ynh[2];
    // f->ynh[2] = f->ynh[1];
    // f->ynh[1] = f->ynh[0];
    // f->ynh[0] = yh;

    f64 yl = filter_process_sample(&f->lp[0], in);
    yl = filter_process_sample(&f->lp[1], yl);

    f64 yh = filter_process_sample(&f->hp[0], in);
    yh = filter_process_sample(&f->hp[1], yh);

    *out_low = yl;
    *out_high = yh;
}
