// gui_mac.m
// gui implementation for MacOS

#import "platform.h"
#include "visual.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <CoreGraphics/CoreGraphics.h>

static pv_KeyMod _osx_key_mod_translate(NSUInteger os_mod) {
    pv_KeyMod result = pv_KeyModifierNone;
    if (os_mod & NSEventModifierFlagControl)
        result |= pv_KeyModifierCtrl;
    if (os_mod & NSEventModifierFlagCommand)
        result |= pv_KeyModifierSuper;
    if (os_mod & NSEventModifierFlagOption)
        result |= pv_KeyModifierAlt;
    if (os_mod & NSEventModifierFlagShift)
        result |= pv_KeyModifierShift;

    return result;
}

// NOTE: sokol will subclass different types depending on the rendering backend, i.e.
// for Metal you subclass `MTKView`, for OpenGL you subclass `NSOpenGLView`,
// and in its WebGPU backend it subclasses `NSView`. For our bland software-rendering
// backend, it seems that NSView is also what we want to subclass, although subclassing
// `NSWindow` may be necessary when creating a desktop app.
@interface OSX_View : NSView
@property (nonatomic) void *user;
@property (nonatomic) pv_Context *ctx;
@property (nonatomic) CGContextRef cg_ref;
@property (nonatomic, copy) NSFont *font_ref;
@property (nonatomic) float font_size;
@property (nonatomic) bool hasSuperView;
@end

@interface OSX_NSDelegate : NSObject<NSApplicationDelegate>
@end

typedef struct {
    OSX_View *view;
    NSWindow *window;
    OSX_NSDelegate *delegate;
    CFRunLoopTimerRef timer_ref;

    CGImageRef icon;

} OSX_VisualContext;

// Used in desktop application
static pv_Context _g_ctx;

#define osx_ctx(c) ((OSX_VisualContext*)(c)->platform_ctx)

static NSPoint _osx_event_mouse_pos(pv_Context *ctx, NSEvent *event) {
    NSPoint cursor = event.locationInWindow;
    OSX_VisualContext *osx = osx_ctx(ctx);
    double height = osx->view.bounds.size.height;
    return (NSPoint){cursor.x, height - cursor.y};
}
static void _osx_mouse_event(pv_Context *ctx, pv_EventType type, pv_MouseButton button, NSPoint pos, pv_KeyMod mod);
static void _osx_key_event(pv_Context *ctx, pv_EventType type, pv_Key key, pv_KeyMod mod, NSPoint mouse_pos);
static void _osx_timer_cb(CFRunLoopTimerRef timer_ref, void *ctx);

@implementation OSX_NSDelegate
- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    printf("%s\n", __func__);
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                       NSWindowStyleMaskMiniaturizable |
                       NSWindowStyleMaskResizable;
    osx_ctx(&_g_ctx)->window = [[NSWindow alloc]
        initWithContentRect:NSMakeRect(0, 0, (float)_g_ctx.desc.width, (float)_g_ctx.desc.height)
                  styleMask:style
                    backing:NSBackingStoreBuffered
                      defer:NO];
    osx_ctx(&_g_ctx)->window.releasedWhenClosed = NO;
    osx_ctx(&_g_ctx)->window.title = [NSString stringWithUTF8String:_g_ctx.desc.title];
    osx_ctx(&_g_ctx)->window.acceptsMouseMovedEvents = YES;
    osx_ctx(&_g_ctx)->window.restorable = YES;
    osx_ctx(&_g_ctx)->view = [[OSX_View alloc] init];
    osx_ctx(&_g_ctx)->view.ctx = &_g_ctx;
    osx_ctx(&_g_ctx)->window.contentView = osx_ctx(&_g_ctx)->view;
    [osx_ctx(&_g_ctx)->window makeFirstResponder:osx_ctx(&_g_ctx)->view];
    [osx_ctx(&_g_ctx)->window center];
    NSApp.activationPolicy = NSApplicationActivationPolicyRegular;
    [NSApp activateIgnoringOtherApps:YES];
    [osx_ctx(&_g_ctx)->window makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    printf("%s\n", __func__);
    // release MacOS objects
    [osx_ctx(&_g_ctx)->view release];
    osx_ctx(&_g_ctx)->view = NULL;
    [osx_ctx(&_g_ctx)->window release];
    osx_ctx(&_g_ctx)->window = NULL;
    [osx_ctx(&_g_ctx)->delegate release];
    osx_ctx(&_g_ctx)->delegate = NULL;
    pv_deinit(&_g_ctx);
}
@end

// TODO Window delegate - necessary for implementing window events like focus/unfocus,
// resizing, windowShouldClose

// This is where we implement most event handling, as well as drawing
@implementation OSX_View
- (void)drawRect:(NSRect)dirtyRect {
    pv_Context *ctx = self.ctx;
    if (!ctx->initialized) {
        if (ctx->desc.init_proc)
            ctx->desc.init_proc(ctx);
        ctx->initialized = true;
        OSX_VisualContext *osx = osx_ctx(ctx);
        if (!osx->view.font_ref) {
            pv_set_font(ctx, STR_LIT("Arial"), 18);
        }
    }
    if (ctx->desc.render_proc)
        ctx->desc.render_proc(ctx);
}

- (BOOL)isOpaque {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
    pv_Context *ctx = self.ctx;
    NSPoint mouse_pos = _osx_event_mouse_pos(ctx, event);
    _osx_mouse_event(ctx, pv_EventMouseDown, pv_MouseLeft, mouse_pos, _osx_key_mod_translate(event.modifierFlags));
}

- (void)mouseUp:(NSEvent *)event {
    pv_Context *ctx = self.ctx;
    NSPoint mouse_pos = _osx_event_mouse_pos(ctx, event);
    _osx_mouse_event(ctx, pv_EventMouseUp, pv_MouseLeft, mouse_pos, _osx_key_mod_translate(event.modifierFlags));
}

- (void)mouseDragged:(NSEvent *)event {
    pv_Context *ctx = self.ctx;
    NSPoint mouse_pos = _osx_event_mouse_pos(ctx, event);
    _osx_mouse_event(ctx, pv_EventMouseDrag, pv_MouseLeft, mouse_pos, _osx_key_mod_translate(event.modifierFlags));
}

- (void)mouseMoved:(NSEvent *)event {
    pv_Context *ctx = self.ctx;
    NSPoint mouse_pos = _osx_event_mouse_pos(ctx, event);
    _osx_mouse_event(ctx, pv_EventMouseMove, pv_MouseNone, mouse_pos, _osx_key_mod_translate(event.modifierFlags));
}

// TODO Right mouse button & middle mouse button methods

- (void)keyDown:(NSEvent *)event {
    uint16_t keycode = event.keyCode;
    NSEventModifierFlags mods = event.modifierFlags;
    pv_Context *ctx = self.ctx;
    NSPoint mouse_pos = _osx_event_mouse_pos(ctx, event);
    _osx_key_event(ctx, pv_EventKeyDown, keycode, _osx_key_mod_translate(mods), mouse_pos);
    const NSString *chars = event.characters;
    const NSUInteger n_chars = chars.length;
    if (n_chars > 0) {
        // TODO
        printf("Char event: %s\n", [chars cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

- (void)keyUp:(NSEvent *)event {
    // TODO
}

@end

static void _osx_loadIcons(pv_Context *ctx) {
    pv_load_image_asset(ctx, STR_LIT("icons.png"));
}

static void _osx_init_render(pv_Desc desc, pv_Context *ctx, Arena *arena) {
    ctx->desc = desc;
    ctx->arena = arena;
    OSX_VisualContext *osx_ctx = arena_alloc(arena, sizeof(OSX_VisualContext));
    ctx->platform_ctx = osx_ctx;

    double timer_ms;
    if (desc.timer_ms > 0)
        timer_ms = (double)desc.timer_ms;
    else
        timer_ms = 16;
    CFRunLoopTimerContext timer = {};
    timer.info = ctx;
    osx_ctx->timer_ref = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent() + timer_ms / 1000,
                                     timer_ms / 1000, 0, 0, _osx_timer_cb, &timer);
    if (!osx_ctx->timer_ref) {
        err("Timer creation failed");
        return;
    }
    CFRunLoopAddTimer(CFRunLoopGetMain(), osx_ctx->timer_ref, kCFRunLoopCommonModes);

    // _osx_loadIcons(ctx);
}

void pv_init_desktop_window(pv_Desc desc) {
    [NSApplication sharedApplication];

    Arena *arena = arena_init();
    _osx_init_render(desc, &_g_ctx, arena);
    // set app delegate
    OSX_NSDelegate *dlg = [[OSX_NSDelegate alloc] init];
    OSX_VisualContext *osx_ctx = _g_ctx.platform_ctx;
    osx_ctx->delegate = dlg;

    NSApp.delegate = osx_ctx->delegate;

    [NSApp run];
}

pv_Context *pv_init_child_window(pv_Desc desc)
{
    NSRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = (float)desc.width;
    frame.size.height = (float)desc.height;
    OSX_View *view = [[OSX_View alloc] initWithFrame:frame];
    view.user = desc.user_data;
    view.cg_ref = NULL;
    view.font_ref = NULL;

    Arena *arena = arena_init();
    pv_Context *ctx = arena_alloc(arena, sizeof(pv_Context));
    _osx_init_render(desc, ctx, arena);
    view.ctx = ctx;
    osx_ctx(ctx)->view = view;

    return ctx;
}

void pv_request_quit(pv_Context *ctx) {
    printf("%s\n", __func__);
    [NSApplication sharedApplication];
    [NSApp terminate:nil];
}

void pv_deinit(pv_Context *ctx)
{
    // call user cleanup function
    if (ctx->desc.cleanup_proc)
        ctx->desc.cleanup_proc(ctx);
    if (osx_ctx(ctx)->timer_ref)
        CFRunLoopTimerInvalidate(osx_ctx(ctx)->timer_ref);
    if (osx_ctx(ctx)->view.font_ref) {
        CFRelease(osx_ctx(ctx)->view.font_ref);
    }
    if (osx_ctx(ctx)->icon) {
        CGImageRelease(osx_ctx(ctx)->icon);
    }

    arena_deinit(ctx->arena);
}

void pv_set_parent(pv_Context *ctx, pv_Window parent)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    if (!parent)
        if (gui.hasSuperView) [gui removeFromSuperview];

    if (gui.hasSuperView) [gui removeFromSuperview];
    [(NSView*)parent addSubview:gui];
    gui.hasSuperView = true;
    [[gui window] setAcceptsMouseMovedEvents:YES];
}

void pv_set_visible(pv_Context *ctx, bool32 visible)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    [gui setHidden:(visible ? NO : YES)];
}

void pv_begin_drawing(pv_Context *ctx)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    gui.cg_ref = [[NSGraphicsContext currentContext] CGContext];
    // [NSGraphicsContext graphicsContextWithCGContext:gui.cg_ref flipped:NO];
    if (gui.cg_ref == NULL) {
        assert(false);
    }
}

void pv_end_drawing(pv_Context *ctx)
{
    // release drawing resources
}

int pv_width(pv_Context *ctx) { return ctx->desc.width; }
int pv_height(pv_Context *ctx) { return ctx->desc.height; }
float pv_widthf(pv_Context *ctx) { return (float)ctx->desc.width; }
float pv_heightf(pv_Context *ctx) { return (float)ctx->desc.height; }
float pv_get_aspect_ratio(pv_Context *ctx) { return (float)ctx->desc.width / (float)ctx->desc.height; }

static void _osx_redraw(pv_Context *ctx) {
    [osx_ctx(ctx)->view setNeedsDisplayInRect:osx_ctx(ctx)->view.bounds];
}

void pv_clear(pv_Context *ctx, av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextFillRect(gui.cg_ref, gui.bounds);
}

void pv_draw_rect(pv_Context *ctx, av_Rect rect, float stroke_width, av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    const float height = gui.bounds.size.height;
    CGContextSetRGBStrokeColor(gui.cg_ref, color.r, color.g, color.b, color.a);

    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = height - rect.y;
    r.size.width = rect.width;
    r.size.height = -rect.height;
    CGContextStrokeRectWithWidth(gui.cg_ref, r, stroke_width);
}

void pv_fill_rect(pv_Context *ctx, av_Rect rect, av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    const float height = gui.bounds.size.height;
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);

    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = height - rect.y;
    r.size.width = rect.width;
    r.size.height = -rect.height;
    CGContextFillRect(gui.cg_ref, r);
}

void pv_draw_rounded_rect(pv_Context *ctx, av_Rect rect, float radius,
                          float stroke_width, av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    const float height = gui.bounds.size.height;

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = height - rect.y;
    r.size.width = rect.width;
    r.size.height = -rect.height;
    CGPathAddRoundedRect(path, NULL, r, radius, radius);
    CGContextSetRGBStrokeColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextAddPath(gui.cg_ref, path);
    CGContextSetLineWidth(gui.cg_ref, stroke_width);
    CGContextStrokePath(gui.cg_ref);
    CGPathRelease(path);
}

void pv_fill_rounded_rect(pv_Context *ctx, av_Rect rect, float radius,
                          av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    const float height = gui.bounds.size.height;

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = height - rect.y;
    r.size.width = rect.width;
    r.size.height = -rect.height;
    CGPathAddRoundedRect(path, NULL, r, radius, radius);
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextAddPath(gui.cg_ref, path);
    CGContextFillPath(gui.cg_ref);

    CGPathRelease(path);
}

// ISSUE stroke width is not utilized
void pv_draw_ellipse(pv_Context *ctx, av_Point center, float rx, float ry,
                    float stroke_width, av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    CGContextSetRGBStrokeColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGRect rect = NSMakeRect(center.x - rx, center.y - ry, rx*2, ry*2);
    CGContextStrokeEllipseInRect(gui.cg_ref, rect);
}

void pv_fill_ellipse(pv_Context *ctx, av_Point center, float rx, float ry,
                    av_Colorf color)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGRect rect = NSMakeRect(center.x - rx, center.y - ry, rx*2, ry*2);
    CGContextFillEllipseInRect(gui.cg_ref, rect);
}

void pv_load_image_asset(pv_Context *ctx, String image_name) {
    Arena *arena = ctx->arena;
    TempAlloc tmp = temp_alloc_begin(arena);
    String path = path_join(&arena->allocator, (String[]){string("assets"), image_name}, 2);
    File img_fd = file_open(path, FileOpen_ReadOnly);
    const char *img_data = file_read_full_alloc(img_fd, &arena->allocator);
    if (!img_data) {
        err("Failed to load image: %.*s\n", image_name.len, image_name.data);
    }

    CFDataRef cfdata = CFDataCreate(NULL, (u8*)img_data, img_fd.size);
    CGImageSourceRef imgsrc = CGImageSourceCreateWithData(cfdata, NULL);
    CGImageRef img = CGImageSourceCreateImageAtIndex(imgsrc, 0, NULL);

    osx_ctx(ctx)->icon = img;

    temp_alloc_end(&tmp);
}

void pv_draw_icon(pv_Context *ctx, pv_IconSlot icon, av_Rect rect, av_Colorf color) {
    OSX_View *view = osx_ctx(ctx)->view;
    const int icon_size = 64;
    float x = icon * icon_size;
    CGImageRef img = CGImageCreateWithImageInRect(osx_ctx(ctx)->icon, NSMakeRect(x, 0, 64, 64));
    const float height = view.bounds.size.height;
    CGRect r = NSMakeRect(rect.x, height - rect.y - rect.height, rect.width, rect.height);
    CGContextDrawImage(osx_ctx(ctx)->view.cg_ref, r, img);
}

void pv_set_font(pv_Context *ctx, String font_name, float size)
{
    STACK_ALLOC_BEGIN(128);
    char *cstr = cstring_from_string(STACK_ALLOC, font_name);
    osx_ctx(ctx)->view.font_ref = [NSFont fontWithName:[[NSString alloc] initWithUTF8String:cstr] size:size];
    osx_ctx(ctx)->view.font_size = size;
    if (osx_ctx(ctx)->view.font_ref == NULL) {
        fprintf(stderr, "NSFont creation failed\n");
        return;
    }
}

float pv_get_current_font_size(pv_Context *ctx) { return osx_ctx(ctx)->view.font_size; }

av_Size pv_measure_text(pv_Context *ctx, String text) {
    TempAlloc tmp = temp_alloc_begin(ctx->arena);
    char *cstr = cstring_from_string(&ctx->arena->allocator, text);
    NSString *str = [[NSString alloc] initWithUTF8String:cstr];

    OSX_VisualContext *osx = osx_ctx(ctx);

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    NSSize sz = [str sizeWithAttributes:@{
        NSFontAttributeName : [osx->view.font_ref fontWithSize:osx->view.font_size],
    }];

    temp_alloc_end(&tmp);
    return (av_Size){.width = sz.width, .height = sz.height};
}

void pv_draw_text(pv_Context *ctx, String text, av_Rect rect, av_TextStyle style, float size)
{
    TempAlloc tmp = temp_alloc_begin(ctx->arena);
    OSX_View *view = osx_ctx(ctx)->view;
    const float height = view.bounds.size.height;
    NSFont *font = view.font_ref;
    char *cstr = cstring_from_string(&ctx->arena->allocator, text);
    NSString *str = [[NSString alloc] initWithUTF8String:cstr];
    NSMutableParagraphStyle *para_style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    switch (style.justify) {
    case av_TextJustifyCenter:
        para_style.alignment = NSTextAlignmentCenter;
        break;
    case av_TextJustifyLeft:
        para_style.alignment = NSTextAlignmentLeft;
        break;
    case av_TextJustifyRight:
        para_style.alignment = NSTextAlignmentRight;
        break;
    }

    NSColor *color = [NSColor colorWithSRGBRed:style.color.r green:style.color.g blue:style.color.b alpha:style.color.a];

    [str drawWithRect:NSMakeRect(rect.x, height - rect.y - rect.height, rect.width, rect.height)
                    options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{
                        NSParagraphStyleAttributeName : para_style,
                        NSFontAttributeName : [view.font_ref fontWithSize:size],
                        NSForegroundColorAttributeName : color,
                    }
                    context:nil];

    temp_alloc_end(&tmp);
}

av_Size pv_get_render_size(pv_Context *ctx)
{
    OSX_View *gui = osx_ctx(ctx)->view;
    return (av_Size){gui.bounds.size.width, gui.bounds.size.height};
}

void pv_set_render_size(pv_Context *ctx, av_Size size) {
    OSX_VisualContext *osx = osx_ctx(ctx);
    [osx->view setFrameSize:(NSSize){.width = (CGFloat)size.width, .height = (CGFloat)size.height}];
}

static void _osx_mouse_event(pv_Context *ctx, pv_EventType type, pv_MouseButton button,
    NSPoint pos, pv_KeyMod mod) {
    pv_Event event = {
        .key = Key_None,
        .type = type,
        .mouse_button = button,
        .mouse_x = (i32)pos.x,
        .mouse_y = (i32)pos.y,
        .modifiers = mod,
    };
    if (ctx->desc.event_proc)
        ctx->desc.event_proc(ctx, &event);
}

static void _osx_key_event(pv_Context *ctx, pv_EventType type, pv_Key key, pv_KeyMod mod,
    NSPoint mouse_pos) {
    pv_Event event = {
        .mouse_x = mouse_pos.x,
        .mouse_y = mouse_pos.y,
        .type = type,
        .key = key,
        .modifiers = mod,
    };
    if (ctx->desc.event_proc)
        ctx->desc.event_proc(ctx, &event);
}

static void _osx_timer_cb(CFRunLoopTimerRef timer_ref, void *ctx) {
    _osx_redraw(ctx);
}

void rdrOnPosixFd(OSX_View *gui) {}
