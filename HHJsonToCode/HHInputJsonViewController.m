//
//  HHInputJsonViewController.m
//  HHJsonToCode
//
//  Created by caohuihui on 2016/11/28.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHInputJsonViewController.h"
#import "HHStructViewController.h"
#import "AppDelegate.h"
#import "HHJsonToCodeTool.h"

@interface HHInputJsonViewController ()<NSTextViewDelegate>
@end

@implementation HHInputJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.textView.delegate = self;
    self.textView.automaticQuoteSubstitutionEnabled = NO;
    
//    [self textDidChange:nil];
}

- (void)viewWillAppear{
    [super viewWillAppear];
    [self checkJsone];
}

#pragma mark - NSTextViewDelegate
- (void)textDidChange:(NSNotification *)notification{
    [self checkJsone];
}


- (void)checkJsone{
    if ([HHJsonToCodeTool checkIsJsonText:self.textView.string]) {
        self.scrollView.layer.borderWidth = 0;
        self.nextBtn.enabled = YES;
    }else{
        self.scrollView.layer.borderWidth = 1;
        self.scrollView.layer.borderColor = [NSColor redColor].CGColor;
        self.nextBtn.enabled = NO;
    }
}

- (IBAction)clickNextButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate showStructVc];
}

@end
