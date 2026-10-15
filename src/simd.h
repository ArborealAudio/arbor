#ifndef ARBOR_SIMD_H
#define ARBOR_SIMD_H

#include "../cbase/cbase.h"

#if ARCH_ARM64
#include <arm_neon.h>
typedef uint32x4_t u32x4;
typedef uint32x2_t u32x2;
typedef uint64x2_t u64x2;
typedef float32x4_t f32x4;
typedef float64x2_t f64x2;
#elif ARCH_X86_64
#include <emmintrin.h>
typedef __m128 f32x4;
#endif

// 32-bit x 4
f32x4 load_f32x4_unaligned(f32 *);
f32x4 load_f32x4_aligned(f32 *);
f32x4 splat_f32x4(f32);
f32x4 add_f32x4(f32x4 a, f32x4 b);
f32x4 sub_f32x4(f32x4 a, f32x4 b);
f32x4 mul_f32x4(f32x4 a, f32x4 b);
f32x4 div_f32x4(f32x4 a, f32x4 b);
f32x4 select_f32x4(u32x4 mask, f32x4 t, f32x4 f);
u32x4 cmp_gt_f32x4(f32x4 a, f32x4 b);
u32x4 cmp_lt_f32x4(f32x4 a, f32x4 b);
u32x4 cmp_ge_f32x4(f32x4 a, f32x4 b);
u32x4 cmp_le_f32x4(f32x4 a, f32x4 b);
u32x4 cmp_eq_f32x4(f32x4 a, f32x4 b);

// 64-bit x 2
f64x2 load_f64x2_unaligned(const f64 *);
f64x2 load_f64x2_aligned(const f64 *);
void store_f64x2_unaligned(f64 *dst, f64x2 v);
f64x2 splat_f64x2(f64);
f64x2 add_f64x2(f64x2 a, f64x2 b);
f64x2 sub_f64x2(f64x2 a, f64x2 b);
f64x2 mul_f64x2(f64x2 a, f64x2 b);
f64x2 div_f64x2(f64x2 a, f64x2 b);
f64x2 select_f64x2(u64x2 mask, f64x2 t, f64x2 f);
u64x2 cmp_gt_f64x2(f64x2 a, f64x2 b);
u64x2 cmp_lt_f64x2(f64x2 a, f64x2 b);
u64x2 cmp_ge_f64x2(f64x2 a, f64x2 b);
u64x2 cmp_le_f64x2(f64x2 a, f64x2 b);
u64x2 cmp_eq_f64x2(f64x2 a, f64x2 b);

#endif
