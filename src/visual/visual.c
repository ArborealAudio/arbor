#include "visual.h"

#if __APPLE__
#include "platform_mac.m"
#endif

#include "ui.c"

av_Colorf av_colorf_from_u32(u32 pixels) {
    av_Colorf c = {
        .r = (float)(pixels & 0xff) / 255.f,
        .g = (float)((pixels >> 8) & 0xff) / 255.f,
        .b = (float)((pixels >> 16) & 0xff) / 255.f,
        .a = (float)((pixels >> 24) & 0xff) / 255.f,
    };
    return c;
}

bool32 av_colorf_is_zero(av_Colorf *s) {
    return memcmp(s, &(av_Colorf){0, 0, 0, 0}, sizeof(av_Colorf)) == 0;
}

bool32 rect_contains(av_Rect r, int x, int y) {
    int right = r.x + r.width;
    int bottom = r.y + r.height;

    return (x >= r.x && x <= right && y >= r.y && y <= bottom);
}

bool32 rect_intersect(av_Rect a, av_Rect b) {
    if (a.x + a.width <= b.x || b.x + b.width <= a.x)
        return FALSE;
    if (a.y + a.height <= b.y || b.y + b.height <= a.y)
        return FALSE;

    return TRUE;
}

av_Rect rect_with_width(av_Rect r, int width) {
    return (av_Rect){r.x, r.y, (float)width, r.height};
}

av_Rect rect_with_height(av_Rect r, int height) {
    return (av_Rect){r.x, r.y, r.width, (float)height};
}

av_Rect rect_translated(av_Rect r, int x, int y) {
    return (av_Rect){r.x + x, r.y + y, r.width, r.height};
}
