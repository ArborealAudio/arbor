// gui_mac.m
// gui implementation for MacOS

#import "render.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>


@interface GuiView : NSView
@property (nonatomic) void *user;
@property (nonatomic) CGContextRef cg_ref;
@property (nonatomic) CTFontRef font_ref;
@property (nonatomic) float font_size;
@property (nonatomic) bool hasSuperView;
@property CFRunLoopTimerRef timer;
@end


@implementation GuiView
- (void)drawRect:(NSRect)dirtyRect {
    // User's drawing functions
    arbor_gui_render(_user);
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

// Adapt mouse y to be consistent w/ more standard top-down method
- (void)mouseDown:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self mouse:cursor inRect:self.bounds]) return;
    float height = self.bounds.size.height;
    arbor_sys_event(_user, cursor.x, height - cursor.y, MouseDown);
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    float height = self.bounds.size.height;
    arbor_sys_event(_user, cursor.x, height - cursor.y, MouseUp);
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self mouse:cursor inRect:self.bounds]) return;
    float height = self.bounds.size.height;
    arbor_sys_event(_user, cursor.x, height - cursor.y, MouseDrag);
}

- (void)mouseMoved:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self mouse:cursor inRect:self.bounds]) return;
    float height = self.bounds.size.height;
    arbor_sys_event(_user, cursor.x, height - cursor.y, MouseOver);
}

// TODO: Override key methods
@end

struct D2DContext{
    GuiView *view;
};

D2DContext *guiInitChildWindow(void *user, int w, int h, u32 timer_ms, const char *id)
{
    (void) id;
    NSRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = (float)w;
    frame.size.height = (float)h;
    GuiView *gui = [[GuiView alloc] initWithFrame:frame];
    gui.user = user;
    gui.cg_ref = NULL;
    gui.font_ref = NULL;

    D2DContext *ctx = (D2DContext*)malloc(sizeof(D2DContext));
    ctx->view = gui;

    CFRunLoopTimerContext timer = {};
    timer.info = gui.user;
    gui.timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent() + (double)timer_ms / 1000,
                                     (double)timer_ms / 1000, 0, 0, arbor_timer_cb, &timer);
    CFRunLoopAddTimer(CFRunLoopGetMain(), gui.timer, kCFRunLoopCommonModes);
    
    return ctx;
}

void guiDeinit(D2DContext *ctx)
{
    CFRunLoopTimerInvalidate(ctx->view.timer);
    if (ctx->view.font_ref) {
        CFRelease(ctx->view.font_ref);
    }
    [(ctx->view) release];
    free(ctx);
}

void guiSetParent(D2DContext *ctx, NSView *parent)
{
    GuiView *gui = ctx->view;
    if (!parent)
        if (gui.hasSuperView) [gui removeFromSuperview];

    // NSView *parentView = (NSView *)parent;
    if (gui.hasSuperView) [gui removeFromSuperview];
    [parent addSubview:gui];
    gui.hasSuperView = true;
    [[gui window] setAcceptsMouseMovedEvents:YES];
}

void guiSetVisible(D2DContext *ctx, bool visible)
{
    GuiView *gui = ctx->view;
    [gui setHidden:(visible ? NO : YES)];
}

void guiBeginDrawing(D2DContext *ctx)
{
    GuiView *gui = ctx->view;
    gui.cg_ref = [[NSGraphicsContext currentContext] CGContext];
    if (gui.cg_ref == NULL) {
        assert(false);
    }
}

void guiEndDrawing(D2DContext *ctx)
{
    // turns out releasing the CGContextRef is a bug?
}

void guiClear(D2DContext *ctx, D2DColor color)
{
    GuiView *gui = ctx->view;
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextFillRect(gui.cg_ref, gui.bounds);
}

void guiDrawRect(D2DContext *ctx, D2DRect rect, float stroke_width, D2DColor color)
{
    GuiView *gui = ctx->view;
    CGContextSetRGBStrokeColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = rect.y;
    r.size.width = rect.width;
    r.size.height = rect.height;
    CGContextStrokeRectWithWidth(gui.cg_ref, r, stroke_width);
}

void guiFillRect(D2DContext *ctx, D2DRect rect, D2DColor color)
{
    GuiView *gui = ctx->view;
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = rect.y;
    r.size.width = rect.width;
    r.size.height = rect.height;
    CGContextFillRect(gui.cg_ref, r);
}

void guiDrawRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          float stroke_width, D2DColor color)
{
    GuiView *gui = ctx->view;

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = rect.y;
    r.size.width = rect.width;
    r.size.height = rect.height;
    CGPathAddRoundedRect(path, NULL, r, radius, radius);
    CGContextSetRGBStrokeColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextAddPath(gui.cg_ref, path);
    CGContextSetLineWidth(gui.cg_ref, stroke_width);
    CGContextStrokePath(gui.cg_ref);
    CGPathRelease(path);
}

void guiFillRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          D2DColor color)
{
    GuiView *gui = ctx->view;

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect r;
    r.origin.x = rect.x;
    r.origin.y = rect.y;
    r.size.width = rect.width;
    r.size.height = rect.height;
    CGPathAddRoundedRect(path, NULL, r, radius, radius);
    CGContextSetRGBFillColor(gui.cg_ref, color.r, color.g, color.b, color.a);
    CGContextAddPath(gui.cg_ref, path);
    CGContextFillPath(gui.cg_ref);

    CGPathRelease(path);
}

void guiLoadFont(D2DContext *ctx, String font_name, float size)
{
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithNameAndSize(
        CFStringCreateWithCStringNoCopy(NULL, font_name, kCFStringEncodingASCII,
                                        kCFAllocatorNull),
        size);
    ctx->view.font_ref = CTFontCreateWithFontDescriptor(desc, size, NULL);
    // CFRelease(desc);

    ctx->view.font_size = size;
    if (ctx->view.font_ref == NULL) {
        fprintf(stderr, "CGFont creation failed\n");
        return;
    }
}

void guiDrawText(D2DContext *ctx, String text, D2DRect rect, D2DColor color)
{
    GuiView *view = ctx->view;
    CFStringRef keys[] = {kCTForegroundColorFromContextAttributeName, kCTFontAttributeName};
    CFTypeRef values[] = {kCFBooleanTrue, view.font_ref};
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void**)keys,
                                  (const void**)values, sizeof(keys)/sizeof(*keys),
                                  &kCFTypeDictionaryKeyCallBacks,
                                  &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef str = CFAttributedStringCreate(
         NULL, CFStringCreateWithCStringNoCopy(
                    NULL, text, kCFStringEncodingUTF8, kCFAllocatorNull
        ), attr);

    CFRelease(attr);
    CTLineRef line = CTLineCreateWithAttributedString(str);
    CFRelease(str);

    CGContextSetRGBFillColor(view.cg_ref, color.r, color.g, color.b, color.a);
    // TODO: Figure out how to properly setup a bounding box for text instead of just using one point.
    // Looks like CTTypesetter is the class we need to use to perform automatic line breaking
    CGContextSetTextPosition(view.cg_ref, rect.x, view.bounds.size.height - rect.y);
    CTLineDraw(line, view.cg_ref);

    CFRelease(line);
}

void guiRedraw(D2DContext *ctx)
{
    GuiView *gui = ctx->view;
    [gui setNeedsDisplayInRect:gui.bounds];
}

D2DSize guiGetRenderSize(D2DContext *ctx)
{
    GuiView *gui = ctx->view;
    return (D2DSize){gui.bounds.size.width, gui.bounds.size.height};
}

void guiOnPosixFd(GuiView *gui) {}
