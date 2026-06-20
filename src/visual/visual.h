#ifndef VISUAL_H
#define VISUAL_H

// av = Arbor Visual
// Platform independent visual types and functions

typedef struct {
    u8 r, g, b, a;
} av_Color;

typedef struct {
    float r, g, b, a;
} av_Colorf;

av_Colorf av_colorf_from_u32(u32 pixels);
bool32 av_colorf_is_zero(av_Colorf *);

typedef struct av_Point {
    float x, y;
} av_Point;

typedef struct {
    float width, height;
} av_Size;

typedef struct {
    float x, y;
} av_Vec2;

typedef struct av_Rect {
    float x, y, width, height;
} av_Rect;

bool32 rect_contains(av_Rect r, int x, int y);
bool32 rect_intersect(av_Rect a, av_Rect b);
av_Rect rect_with_width(av_Rect r, int width);
av_Rect rect_with_height(av_Rect r, int height);
av_Rect rect_translated(av_Rect r, int x, int y);

typedef enum {
    av_TextJustifyCenter,
    av_TextJustifyLeft,
    av_TextJustifyRight,
} av_TextJustify;

typedef enum {
    av_TextAlignInside,
    av_TextAlignAbove,
    av_TextAlignBelow,
    av_TextAlignLeft,
    av_TextAlignRight,
} av_TextAlign;

typedef struct {
    av_TextJustify justify;
    av_TextAlign align;
    float padding; // equal padding on all sides
    av_Colorf color;
    // TODO size
    // TODO font?
} av_TextStyle;

#include "platform.h"
#include "ui.h"

#endif
