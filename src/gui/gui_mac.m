// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

struct Plugin;
void implInputEvent(struct Plugin *plugin, int32_t cursorX, int32_t cursorY, int8_t button);

@interface MainView : NSView
@property (nonatomic) struct Plugin *plugin;
@property (nonatomic) uint32_t *bits;
@property (nonatomic) uint32_t width;
@property (nonatomic) uint32_t height;
@property (nonatomic) BOOL hasSuperView;
@end

@implementation MainView
- (void)drawRect:(NSRect)dirtyRect {
    const unsigned char *data = (const unsigned char *)_bits;
    NSDrawBitmap(self.bounds, _width, _height, 8 /*bits per channel*/,
    4 /*channels per pixel*/, 32 /*bits per pixel*/,
    4 * _width /*bytes per row*/, NO, NO, NSDeviceRGBColorSpace, &data);
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    implInputEvent(_plugin, cursor.x, cursor.y, 1);
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    implInputEvent(_plugin, cursor.x, cursor.y, -1);
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
    implInputEvent(_plugin, cursor.x, cursor.y, 0);
}
@end

void *implGuiCreate(struct Plugin *plugin, uint32_t *bits, uint32_t w, uint32_t h)
{
    NSRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = w;
    frame.size.height = h;
    MainView *mainView = [[MainView alloc] initWithFrame:frame];
    mainView.plugin = plugin;
    mainView.bits = bits;
    mainView.width = w;
    mainView.height = h;
    return mainView;
}

void implGuiDestroy(void *mainView)
{
    [((MainView *) mainView) release];
}

void implGuiSetParent(const void *disp, const void *pluginView, const void *parent)
{
    MainView *mainView = (MainView *)pluginView;
    NSView *parentView = (NSView *)parent;
    if (mainView.hasSuperView) [mainView removeFromSuperview];
    [parentView addSubview:mainView];
    mainView.hasSuperView = true;
}

void implGuiSetVisible(const void *disp, const void *pluginView, bool visible)
{
    MainView *mainView = (MainView *)pluginView;
    [mainView setHidden:(visible ? NO : YES)];
}

void implGuiRender(void *pluginView)
{
    MainView *mainView = (MainView *)pluginView;
    [mainView setNeedsDisplayInRect:mainView.bounds];
}
