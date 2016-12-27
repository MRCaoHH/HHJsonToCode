//
//  HHPropertyModel.h
//  HHJsonToCode
//
//  Created by caohuihui on 2016/12/26.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHPropertyModel : NSObject


/**
 属性名字
 */
@property (nonatomic, copy) NSString *name;


/**
 注释
 */
@property (nonatomic, copy) NSString *note;


/**
 类名
 */
@property (nonatomic, copy) NSString *typeName;


/**
 修饰属性
 */
@property (nonatomic, copy) NSString *modification;


/**
 是否是指针类型
 */
@property (nonatomic, assign) BOOL pointer;
@end
