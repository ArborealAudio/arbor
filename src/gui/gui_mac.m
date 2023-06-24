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
    NSView *pluginView = [pluginWindow contentView];
    NSView *parentView = (NSView *)parent;
    // if ([pluginView superview] != nil) [pluginView removeFromSuperview];
    [parentView addSubview:pluginView];
    // mainView.hasSuperView = true;
}

void implGuiSetVisible(const void *disp, const void *_mainView, bool visible)
{
    NSView *mainView = (NSView *)_mainView;
    [mainView setHidden:(visible ? NO : YES)];
}
