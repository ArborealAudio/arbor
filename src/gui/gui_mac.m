// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

void inputEvent(void *user, int32_t cursorX, int32_t cursorY, int8_t button);
void render(void *);

@interface GuiImpl : NSView
@property (nonatomic) void *user;
@property (nonatomic) uint32_t *bits;
@property (nonatomic) uint32_t width;
@property (nonatomic) uint32_t height;
@property (nonatomic) BOOL hasSuperView;
@end

@implementation GuiImpl
- (void)drawRect:(NSRect)dirtyRect {
    render(_user);
    const unsigned char *data = (const unsigned char *)_bits;
    NSDrawBitmap(self.bounds, _width, _height, 8 /*bits per channel*/,
    4 /*channels per pixel*/, 32 /*bits per pixel*/,
    4 * _width /*bytes per row*/, NO /*planar*/, NO /*alpha*/, NSDeviceRGBColorSpace, &data);
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    inputEvent(_user, cursor.x, cursor.y, 1);
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    inputEvent(_user, cursor.x, cursor.y, -1);
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    inputEvent(_user, cursor.x, cursor.y, 0);
}
@end

GuiImpl *guiCreate(void *user, uint32_t *bits, uint32_t w, uint32_t h)
{
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
    return gui;
}

void guiDestroy(GuiImpl *gui)
{
    [((GuiImpl *) gui) release];
}

void guiSetParent(GuiImpl *gui, const void *parent)
{
    NSView *parentView = (NSView *)parent;
    if (gui.hasSuperView) [gui removeFromSuperview];
    [parentView addSubview:gui];
    gui.hasSuperView = true;
}

void guiSetVisible(GuiImpl *gui, bool visible)
{
    [gui setHidden:(visible ? NO : YES)];
}

void guiRender(GuiImpl *gui)
{
    [gui setNeedsDisplayInRect:gui.bounds];
}

void guiOnPosixFd(GuiImpl *) {}
