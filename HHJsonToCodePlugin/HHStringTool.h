//
//  HHStringTool.h
//  HHJsonToCode
//
//  Created by caohuihui on 2016/11/29.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHStringTool : NSObject


/**
 去掉空白字符

 @param string 带去掉空白字符的字符串
 */
+ (NSString *)removeSpacesChat:(NSString *)string;


/**
 改变大小写

 @param string 待改编的字符喘
 @param capital 是否是大写
 */
+ (NSString *)changeCaseSize:(NSString *)string capital:(BOOL)capital;

@end
