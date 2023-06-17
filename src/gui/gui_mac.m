// gui_mac.m
// gui implementation for MacOS

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <clap/clap.h>

@interface MainView : NSView
@property (nonatomic) BOOL hasSuperView;
@end

void implGuiSetParent(const void *_mainView, const clap_window_t *window)
{
    MainView *mainView = (MainView *)_mainView;
    NSView *parentView = (NSView *)window->cocoa;
    // if (mainView.hasSuperView) [mainView removeFromSuperview];
    [parentView addSubview:mainView];
    // mainView.hasSuperView = true;
}

void implGuiSetVisible(const void *_mainView, bool visible)
{
    MainView *mainView = (MainView *)_mainView;
    [mainView setHidden:(visible ? NO : YES)];
}
