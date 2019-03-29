//
//  NSString+HHExtension.h
//  HHJsonToCode
//
//  Created by henry on 2018/1/26.
//  Copyright © 2018年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HHExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)xy_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)xy_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)xy_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)xy_firstCharLower;

@end
