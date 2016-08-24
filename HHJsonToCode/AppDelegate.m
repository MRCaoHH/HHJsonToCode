//
//  AppDelegate.m
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "AppDelegate.h"
#import "HHJsonToCodeTool.h"
#import "HHJsonToCodeController.h"
@interface AppDelegate ()
@property (nonatomic, strong) HHJsonToCodeController *windController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.windController = [[HHJsonToCodeController alloc]initWithWindowNibName:@"HHJsonToCodeController"];
    [self.windController showWindow:self.windController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:NSWindowWillCloseNotification object:nil];
}

- (void)closeWindow{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:nil];
    [[NSApplication sharedApplication]terminate:[NSApplication sharedApplication]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
