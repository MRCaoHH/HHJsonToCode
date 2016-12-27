//
//  HHInputJsonViewController.h
//  HHJsonToCode
//
//  Created by caohuihui on 2016/11/28.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HHInputJsonViewController : NSViewController
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSButton *nextBtn;
@property (weak) IBOutlet NSScrollView *scrollView;

@end
