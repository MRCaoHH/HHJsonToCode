//
//  HHJsonToCodePlugin.h
//  HHJsonToCodePlugin
//
//  Created by caohuihui on 16/8/24.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HHJsonToCodePlugin : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end