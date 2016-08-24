//
//  HHJsonToCodeController.m
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/24.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHJsonToCodeController.h"
#import "HHJsonToCodeTool.h"
@interface HHJsonToCodeController ()<NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;

@end

@implementation HHJsonToCodeController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.jsonTextView.delegate = self;
    self.codeTextView.delegate = self;
    self.jsonTextView.automaticQuoteSubstitutionEnabled = NO;
    self.codeTextView.automaticQuoteSubstitutionEnabled = NO;
}

#pragma mark - NSTextViewDelegate
- (void)textDidChange:(NSNotification *)notification{
    id textView  = notification.object;
    if ([textView isEqual:self.jsonTextView]) {
        if ([HHJsonToCodeTool checkIsJsonText:self.jsonTextView.string]) {
            self.jsonTextView.layer.borderWidth = 0;
            [self outputCode];
        }else{
            self.jsonTextView.layer.borderWidth = 1;
            self.jsonTextView.layer.borderColor = [NSColor redColor].CGColor;
        }
    }

    if ([textView isEqual:self.codeTextView]) {
        
    }
}


- (void)outputCode{
    self.codeTextView.string = [HHJsonToCodeTool getCodeDoc:[HHJsonToCodeTool objectWithJsonText:self.jsonTextView.string] className:@"Data"];
}

#pragma makr - click button
- (IBAction)clickCreateBtn:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel setDirectoryURL:[NSURL fileURLWithPath:@"~/Desktop/"]];
    typeof(self) weakSelf = self;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result) {
            [weakSelf saveAction:[panel URL].path];
        }
    }];
}

- (void)saveAction:(NSString *)path{
    NSArray *arr = [HHJsonToCodeTool getCodeArr:self.codeTextView.string];
    for (HHCodeMode *model in arr) {
        [self saveFile:model suffix:0 path:path];
    }
    
    NSString *cmd = [NSString stringWithFormat:@"open %@",path];
    system([cmd UTF8String]);
}

- (void)saveFile:(HHCodeMode *)model suffix:(NSInteger )suffix path:(NSString *)path{
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@",model.className,({
        NSString *suffString = suffix ? [NSString stringWithFormat:@"(%zd)",suffix] : @"";
        suffString;
    }),({
        NSString *suffix = model.type ? @"m" :@"h";
        suffix;
    })];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self saveFile:model suffix:++suffix path:path];
        return;
    }
    [model.code writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)clickSettingBtn:(id)sender {
    
}

@end
