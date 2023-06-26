// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

//@interface MainView : NSView
//@property (nonatomic) BOOL hasSuperView;
//@end

void *implGuiCreateDisplay()
{}

void implGuiSetParent(const void *disp, const void *_pluginWindow, const void *parent)
{
    NSWindow *pluginWindow = (NSWindow *)_pluginWindow;
    // NSView *pluginView = [pluginWindow contentView];
    NSView *parentView = (NSView *)parent;
    NSWindow *parentWindow = [parentView window];
    [pluginWindow setExcludedFromWindowsMenu: YES];
    [pluginWindow setCanHide: YES];
    [parentWindow addChildWindow: pluginWindow
                        ordered: NSWindowAbove];
    [parentWindow orderFront: nil];
    [pluginWindow orderFront: nil];
    // if ([pluginView superview] != nil) [pluginView removeFromSuperview];
    // [parentView addSubview:pluginView];
    // mainView.hasSuperView = true;
}

void implGuiSetVisible(const void *disp, const void *_pluginWindow, bool visible)
{
    NSWindow *mainWindow = (NSWindow *)_pluginWindow;
    NSView *mainView = [mainWindow contentView];
    [mainView setHidden:(visible ? NO : YES)];
}
