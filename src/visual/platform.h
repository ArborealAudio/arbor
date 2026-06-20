#ifndef PLATFORM_H
#define PLATFORM_H

#include "../../cbase/cbase.h"

typedef void* pv_Window;
typedef usize pv_Timer;
typedef usize pv_KeyMod;

// pv = Platform Visual

typedef enum {
    pv_IconExpanderClosed,
    pv_IconExpanderOpen,
    pv_IconX,
    pv_IconSlotCount,
} pv_IconSlot;

// TODO Move most of these pv_ types to the GUI header
typedef u8 pv_EventType;
enum pv_EventTypes {
    pv_EventNone,
    pv_EventMouseMove,
    pv_EventMouseDown,
    pv_EventMouseUp,
    pv_EventMouseDrag,
    pv_EventKeyDown,
    pv_EventKeyUp
};

typedef u8 pv_MouseButton;
enum pv_MouseButtons {
    pv_MouseNone = 0,
    pv_MouseLeft = 1 << 0,
    pv_MouseRight = 1 << 1,
    pv_MouseMiddle = 1 << 2,
};

enum pv_KeyModifierFlags {
    pv_KeyModifierNone = 0,
    pv_KeyModifierShift = 1 << 0,
    pv_KeyModifierCtrl = 1 << 1,
    pv_KeyModifierSuper = 1 << 2,
    pv_KeyModifierAlt = 1 << 3,
};

// Obviously this doesn't work if you have multiple mods at once. But...it's nice to have when
// you're confident you'll mostly have just one at a time.
// TODO Supply different/proper names based on pv_
static const char *key_modifier_names[] = {
    [0] = "None",
    [pv_KeyModifierShift] = "Shift",
    [pv_KeyModifierCtrl] = "Ctrl",
    [pv_KeyModifierCtrl|pv_KeyModifierShift] = "Ctrl + Shift",
    [pv_KeyModifierSuper] = "Super",
    [pv_KeyModifierCtrl|pv_KeyModifierSuper] = "Ctrl + Super",
    [pv_KeyModifierAlt] = "Alt",
    [pv_KeyModifierAlt|pv_KeyModifierShift] = "Alt + Shift",
};

// Adapted from Macpv_ Carbon/Cocoa keycodes
enum pv_Keys {
    Key_None = -1,
    Key_A = 0x00,
    Key_S = 0x01,
    Key_D = 0x02,
    Key_F = 0x03,
    Key_H = 0x04,
    Key_G = 0x05,
    Key_Z = 0x06,
    Key_X = 0x07,
    Key_C = 0x08,
    Key_V = 0x09,
    Key_B = 0x0B,
    Key_Q = 0x0C,
    Key_W = 0x0D,
    Key_E = 0x0E,
    Key_R = 0x0F,
    Key_Y = 0x10,
    Key_T = 0x11,
    Key_1 = 0x12,
    Key_2 = 0x13,
    Key_3 = 0x14,
    Key_4 = 0x15,
    Key_6 = 0x16,
    Key_5 = 0x17,
    Key_Equal = 0x18,
    Key_9 = 0x19,
    Key_7 = 0x1A,
    Key_Minus = 0x1B,
    Key_8 = 0x1C,
    Key_0 = 0x1D,
    Key_RightBracket = 0x1E,
    Key_O = 0x1F,
    Key_U = 0x20,
    Key_LeftBracket = 0x21,
    Key_I = 0x22,
    Key_P = 0x23,
    Key_L = 0x25,
    Key_J = 0x26,
    Key_Quote = 0x27,
    Key_K = 0x28,
    Key_Semicolon = 0x29,
    Key_Backslash = 0x2A,
    Key_Comma = 0x2B,
    Key_Slash = 0x2C,
    Key_N = 0x2D,
    Key_M = 0x2E,
    Key_Period = 0x2F,
    Key_Grave = 0x32,
    Key_KeypadDecimal = 0x41,
    Key_KeypadMultiply = 0x43,
    Key_KeypadPlus = 0x45,
    Key_KeypadClear = 0x47,
    Key_KeypadDivide = 0x4B,
    Key_KeypadEnter = 0x4C,
    Key_KeypadMinus = 0x4E,
    Key_KeypadEquals = 0x51,
    Key_Keypad0 = 0x52,
    Key_Keypad1 = 0x53,
    Key_Keypad2 = 0x54,
    Key_Keypad3 = 0x55,
    Key_Keypad4 = 0x56,
    Key_Keypad5 = 0x57,
    Key_Keypad6 = 0x58,
    Key_Keypad7 = 0x59,
    Key_Keypad8 = 0x5B,
    Key_Keypad9 = 0x5C,
    Key_Return = 0x24,
    Key_Tab = 0x30,
    Key_Space = 0x31,
    Key_Delete = 0x33,
    Key_Escape = 0x35,
    Key_Command = 0x37,
    Key_Shift = 0x38,
    Key_CapsLock = 0x39,
    Key_Option = 0x3A,
    Key_Control = 0x3B,
    Key_RightCommand = 0x36,
    Key_RightShift = 0x3C,
    Key_RightOption = 0x3D,
    Key_RightControl = 0x3E,
    Key_Function = 0x3F,
    Key_F17 = 0x40,
    Key_VolumeUp = 0x48,
    Key_VolumeDown = 0x49,
    Key_Mute = 0x4A,
    Key_F18 = 0x4F,
    Key_F19 = 0x50,
    Key_F20 = 0x5A,
    Key_F5 = 0x60,
    Key_F6 = 0x61,
    Key_F7 = 0x62,
    Key_F3 = 0x63,
    Key_F8 = 0x64,
    Key_F9 = 0x65,
    Key_F11 = 0x67,
    Key_F13 = 0x69,
    Key_F16 = 0x6A,
    Key_F14 = 0x6B,
    Key_F10 = 0x6D,
    Key_ContextualMenu = 0x6E,
    Key_F12 = 0x6F,
    Key_F15 = 0x71,
    Key_Help = 0x72,
    Key_Home = 0x73,
    Key_PageUp = 0x74,
    Key_ForwardDelete = 0x75,
    Key_F4 = 0x76,
    Key_End = 0x77,
    Key_F2 = 0x78,
    Key_PageDown = 0x79,
    Key_F1 = 0x7A,
    Key_LeftArrow = 0x7B,
    Key_RightArrow = 0x7C,
    Key_DownArrow = 0x7D,
    Key_UpArrow = 0x7E
};
typedef i16 pv_Key;

typedef struct pv_Context pv_Context;

typedef struct {
    pv_EventType type;
    pv_MouseButton mouse_button;
    i32 mouse_x;
    i32 mouse_y;
    pv_KeyMod modifiers;
    pv_Key key;
} pv_Event;

typedef void (*pv_InitProc)(pv_Context *);
typedef void (*pv_RenderProc)(pv_Context *);
typedef void (*pv_EventProc)(pv_Context *, pv_Event *);
typedef void (*pv_CleanupProc)(pv_Context *);

typedef struct {
    int width;
    int height;
    const char *title;
    u32 timer_ms;
    pv_InitProc init_proc;
    pv_RenderProc render_proc;
    pv_EventProc event_proc;
    pv_CleanupProc cleanup_proc;
    void *user_data;
} pv_Desc;

struct pv_Context {
    pv_Desc desc;
    Arena *arena;

    void *platform_ctx;

    bool32 initialized;
};

void pv_init_desktop_window(pv_Desc desc);
pv_Context *pv_init_child_window(pv_Desc desc);
void pv_request_quit(pv_Context*);
void pv_deinit(pv_Context*);
void pv_begin_drawing(pv_Context *ctx);
void pv_end_drawing(pv_Context *ctx);
void pv_clear(pv_Context *ctx, av_Colorf color);

// Drawing shapes
void pv_draw_rect(pv_Context *ctx, av_Rect rect, float stroke_width, av_Colorf color);
void pv_fill_rect(pv_Context *ctx, av_Rect rect, av_Colorf color);
void pv_draw_rounded_rect(pv_Context *ctx, av_Rect rect, float radius,
                          float stroke_width, av_Colorf color);
void pv_fill_rounded_rect(pv_Context *ctx, av_Rect rect, float radius,
                          av_Colorf color);
void pv_draw_ellipse(pv_Context *ctx, av_Point center, float rx, float ry,
                      float stroke_width, av_Colorf color);
void pv_fill_ellipse(pv_Context *ctx, av_Point center, float rx, float ry,
                      av_Colorf color);

// Drawing images & icons
void pv_load_image_asset(pv_Context *ctx, String image_name);
void pv_draw_icon(pv_Context *ctx, pv_IconSlot icon, av_Rect rect, av_Colorf color);

// Drawing text
void pv_set_font(pv_Context *ctx, String font_name, float size);
float pv_get_current_font_size(pv_Context *ctx);
av_Size pv_measure_text(pv_Context *ctx, String text);
void pv_draw_text(pv_Context *ctx, String text, av_Rect rect, av_TextStyle style, float size);

// Helpers & misc functions
av_Size pv_get_render_size(pv_Context *ctx);
void pv_set_render_size(pv_Context *ctx, av_Size size);
void pv_set_parent(pv_Context*, pv_Window parent);
void pv_set_visible(pv_Context*, bool32);
int pv_width(pv_Context*);
int pv_height(pv_Context*);
float pv_widthf(pv_Context*);
float pv_heightf(pv_Context*);
float pv_get_aspect_ratio(pv_Context*);

#endif
