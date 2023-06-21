// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface MainView : NSView
@property (nonatomic) BOOL hasSuperView;
@end

void *implGuiCreateDisplay()
{}

void implGuiSetParent(const void *disp, const void *_mainView, const void *window)
{
    MainView *mainView = (MainView *)_mainView;
    NSView *parentView = (NSView *)window;
    // if (mainView.hasSuperView) [mainView removeFromSuperview];
    // [parentView addSubview:mainView];
    // mainView.hasSuperView = true;
}

void implGuiSetVisible(const void *disp, const void *_mainView, bool visible)
{
    MainView *mainView = (MainView *)_mainView;
    // [mainView setHidden:(visible ? NO : YES)];
}
