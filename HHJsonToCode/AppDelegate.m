//
//  AppDelegate.m
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "AppDelegate.h"
#import "HHJsonToCodeTool.h"
#import "HHInputJsonViewController.h"
#import "HHStructViewController.h"
#import <objc/runtime.h>
#import <Quartz/Quartz.h>


@interface AppDelegate ()<NSWindowDelegate>
{
    
    __weak IBOutlet NSView *bodyView;
    HHInputJsonViewController *_jsonVc;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _jsonVc = [[HHInputJsonViewController alloc]initWithNibName:@"HHInputJsonViewController" bundle:[NSBundle mainBundle]];
    [self showJsonVc];
    self.window.delegate = self;
}

- (void)windowWillClose:(NSNotification *)notification{
    [[NSApplication sharedApplication]terminate:[NSApplication sharedApplication]];
}

- (void)showJsonVc{
    self.window.contentViewController = _jsonVc;
}

- (void)showStructVc{
    HHStructViewController *structVc = [[HHStructViewController alloc]initWithNibName:@"HHStructViewController" bundle:[NSBundle mainBundle]];
    structVc.json = _jsonVc.textView.string;
    self.window.contentViewController = structVc;
}

@end
