//
//  HHStringTool.m
//  HHJsonToCode
//
//  Created by caohuihui on 2016/11/29.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHStringTool.h"

@implementation HHStringTool

+ (NSString *)removeSpacesChat:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@"" withString:@" "];
}


+ (NSString *)changeCaseSize:(NSString *)string capital:(BOOL)capital{
//    uppercaseString大写
//    lowercaseString小写
    return capital ? [string uppercaseString]:[string lowercaseString];
}
@end
