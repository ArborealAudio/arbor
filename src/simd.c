#include "simd.h"
#include <arm_neon.h>

#if ARCH_ARM64
f32x4 load_f32x4_unaligned(f32 *ptr) { return vld1q_f32(ptr); }
f32x4 load_f32x4_aligned(f32 *ptr) { return vld1q_f32(__builtin_assume_aligned(ptr, 16)); }
f32x4 splat_f32x4(f32 v) { return vmovq_n_f32(v); }

f32x4 add_f32x4(f32x4 a, f32x4 b) {
    return vaddq_f32(a, b);
}

f32x4 sub_f32x4(f32x4 a, f32x4 b) {
    return vsubq_f32(a, b);
}

f32x4 mul_f32x4(f32x4 a, f32x4 b) {
    return vmulq_f32(a, b);
}

f32x4 div_f32x4(f32x4 a, f32x4 b) {
    return vdivq_f32(a, b);
}

f32x4 select_f32x4(u32x4 mask, f32x4 t, f32x4 f) {
    return vbslq_f32(mask, t, f);
}

u32x4 cmp_gt_f32x4(f32x4 a, f32x4 b) {
    return vcgtq_f32(a, b);
}

u32x4 cmp_lt_f32x4(f32x4 a, f32x4 b) {
    return vcltq_f32(a, b);
}

u32x4 cmp_ge_f32x4(f32x4 a, f32x4 b) {
    return vcgeq_f32(a, b);
}

u32x4 cmp_le_f32x4(f32x4 a, f32x4 b) {
    return vcleq_f32(a, b);
}

u32x4 cmp_eq_f32x4(f32x4 a, f32x4 b) {
    return vceqq_f32(a, b);
}

f64x2 load_f64x2_unaligned(const f64 *ptr) { return vld1q_f64(ptr); }

f64x2 load_f64x2_aligned(const f64 *ptr) { return vld1q_f64(__builtin_assume_aligned(ptr, 16)); }

void store_f64x2_unaligned(f64 *dst, f64x2 v) {
    vst1q_f64(dst, v);
}

f64x2 splat_f64x2(f64 v) { return vmovq_n_f64(v); }

f64x2 add_f64x2(f64x2 a, f64x2 b) {
    return vaddq_f64(a, b);
}

f64x2 sub_f64x2(f64x2 a, f64x2 b) {
    return vsubq_f64(a, b);
}

f64x2 mul_f64x2(f64x2 a, f64x2 b) {
    return vmulq_f64(a, b);
}

f64x2 div_f64x2(f64x2 a, f64x2 b) {
    return vdivq_f64(a, b);
}

f64x2 select_f64x2(u64x2 mask, f64x2 t, f64x2 f) {
    return vbslq_f64(mask, t, f);
}

u64x2 cmp_gt_f64x2(f64x2 a, f64x2 b) {
    return vcgtq_f64(a, b);
}

u64x2 cmp_lt_f64x2(f64x2 a, f64x2 b) {
    return vcltq_f64(a, b);
}

u64x2 cmp_ge_f64x2(f64x2 a, f64x2 b) {
    return vcgeq_f64(a, b);
}

u64x2 cmp_le_f64x2(f64x2 a, f64x2 b) {
    return vcleq_f64(a, b);
}

u64x2 cmp_eq_f64x2(f64x2 a, f64x2 b) {
    return vceqq_f64(a, b);
}
#endif
