// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

struct MyPlugin;
void MacInputEvent(struct MyPlugin *plugin, int32_t cursorX, int32_t cursorY,
                   int8_t button);

@interface MainView : NSView
@property(nonatomic) struct MyPlugin *plugin;
@property(nonatomic) uint32_t *bits;
@property(nonatomic) uint32_t width;
@property(nonatomic) uint32_t height;
@property(nonatomic) BOOL hasSuperView;
@end

@implementation MainView
- (void)drawRect:(NSRect)dirtyRect
{
  const unsigned char *data = (const unsigned char *)_bits;
  NSDrawBitmap(self.bounds, _width, _height, 8 /*bits per channel*/,
               4 /*channels per pixel*/, 32 /*bits per pixel*/,
               4 * _width /*bytes per row*/, NO /*planar*/, NO /*has alpha*/,
               NSDeviceRGBColorSpace, &data);
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
  return YES;
}

- (void)mouseDown:(NSEvent *)event
{
  NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
  MacInputEvent(_plugin, cursor.x, cursor.y, 1);
}

- (void)mouseUp:(NSEvent *)event
{
  NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
  MacInputEvent(_plugin, cursor.x, cursor.y, -1);
}

- (void)mouseDragged:(NSEvent *)event
{
  NSPoint cursor = [self convertPoint:[event locationInWindow] fromView:nil];
  MacInputEvent(_plugin, cursor.x, cursor.y, 0);
}

@end

void *MacInitialise(struct MyPlugin *plugin, uint32_t *bits, uint32_t width,
                    uint32_t height)
{
  NSRect frame;
  frame.origin.x = 0;
  frame.origin.y = 0;
  frame.size.width = width;
  frame.size.height = height;
  MainView *mainView = [[MainView alloc] initWithFrame:frame];
  mainView.plugin = plugin;
  mainView.bits = bits;
  mainView.width = width;
  mainView.height = height;
  return mainView;
}

void MacDestroy(void *mainView)
{
    [((MainView *) mainView) release];
}

void MacSetParent(void *_mainView, void *_parentView)
{
    MainView *mainView = (MainView *)_mainView;
    NSView *parentView = (NSView *)_parentView;
    if (mainView.hasSuperView) [mainView removeFromSuperview];
    [parentView addSubview:mainView];
    mainView.hasSuperView = true;
}

void MacSetVisible(void *_mainView, bool show)
{
    MainView *mainView = (MainView *)_mainView;
    [mainView setHidden:(show ? NO : YES)];
}

void MacPaint(void *_mainView)
{
    MainView *mainView = (MainView *)_mainView;
    [mainView setNeedsDisplayInRect:mainView.bounds];
}
