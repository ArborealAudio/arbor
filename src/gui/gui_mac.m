// gui_mac.m
// gui implementation for MacOS

#include <stdbool.h>
#include <stdio.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

enum {
    Idle,
    MouseOver,
    MouseDown,
    MouseUp,
    MouseDrag,
};

extern void sysInputEvent(void *user, int32_t cursorX, int32_t cursorY, uint8_t state);
extern void gui_render(void *user);

@interface GuiImpl : NSView
@property (nonatomic) void *user;
@property (nonatomic) uint32_t *bits;
@property (nonatomic) uint32_t width;
@property (nonatomic) uint32_t height;
@property (nonatomic) bool hasSuperView;
@property CFRunLoopTimerRef timer;
@end

@implementation GuiImpl
- (void)drawRect:(NSRect)dirtyRect {
    gui_render(_user);
    CGContextRef cg_context = [[NSGraphicsContext currentContext] CGContext];
    if (cg_context == NULL) return;
    CGColorSpaceRef color_space = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, _bits, _width * _height * 4, NULL);
    CGImageRef image = CGImageCreate(_width, _height, 8, 32, _width * 4, color_space,
                  kCGBitmapByteOrder32Little | kCGImageAlphaFirst, provider, NULL, false, kCGRenderingIntentDefault);
    CGColorSpaceRelease(color_space);
    CGDataProviderRelease(provider);
    CGContextDrawImage(cg_context, self.bounds, image);
    CGImageRelease(image);
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
    sysInputEvent(_user, cursor.x, _height - cursor.y, MouseDown);
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    sysInputEvent(_user, cursor.x, _height - cursor.y, MouseUp);
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self mouse:cursor inRect:self.bounds]) return;
    sysInputEvent(_user, cursor.x, _height - cursor.y, MouseDrag);
}

- (void)mouseMoved:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    if (![self mouse:cursor inRect:self.bounds]) return;
    sysInputEvent(_user, cursor.x, _height - cursor.y, MouseOver);
}

// TODO: Override key methods
@end

void guiTimerCallback(CFRunLoopTimerRef timer, void *info);

GuiImpl *guiCreate(void *user, uint32_t *bits, uint32_t w, uint32_t h, uint32_t timer_ms, const char *id)
{
    (void) id;
    NSRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = w;
    frame.size.height = h;
    GuiImpl *gui = [[GuiImpl alloc] initWithFrame:frame];
    gui.user = user;
    gui.bits = bits;
    gui.width = w;
    gui.height = h;

    CFRunLoopTimerContext timer = {};
    timer.info = gui.user;
    gui.timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent() + (double)timer_ms / 1000,
                                     (double)timer_ms / 1000, 0, 0, guiTimerCallback, &timer);
    CFRunLoopAddTimer(CFRunLoopGetMain(), gui.timer, kCFRunLoopCommonModes);
    
    return gui;
}

void guiDestroy(GuiImpl *gui)
{
    CFRunLoopTimerInvalidate(gui.timer);
    [((GuiImpl *) gui) release];
}

void guiSetParent(GuiImpl *gui, const void *parent)
{
    if (!parent)
        if (gui.hasSuperView) [gui removeFromSuperview];

    NSView *parentView = (NSView *)parent;
    if (gui.hasSuperView) [gui removeFromSuperview];
    [parentView addSubview:gui];
    gui.hasSuperView = true;
    [[gui window] setAcceptsMouseMovedEvents:YES];
}

void guiSetVisible(GuiImpl *gui, bool visible)
{
    [gui setHidden:(visible ? NO : YES)];
}

void guiRender(GuiImpl *gui)
{
    [gui setNeedsDisplayInRect:gui.bounds];
}

void guiOnPosixFd(GuiImpl *gui) {}
