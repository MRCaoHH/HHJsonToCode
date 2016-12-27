//
//  HHJsonToCodeTool.h
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *kName = @"Name";
static NSString *kType = @"Type";
static NSString *kModification = @"Modification";
static NSString *kNote = @"Note";
static NSString *kPointer = @"Pointer";

@class HHClassModel;
@class HHTreeNode;

typedef NS_ENUM(NSInteger,HHFileType) {
    HHFileType_H = 0,
    HHFileType_M = 1
};

@interface HHCodeMode : NSObject
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) HHFileType type;
@end

@interface HHJsonToCodeTool : NSObject

+ (NSString *)getUserName;

+ (BOOL)checkIsJsonText:(NSString *)jsonText;
+ (id)objectWithJsonText:(NSString *)jsonText;
+ (NSString *)modificationWithClassName:(NSString *)className;
+ (BOOL)pointerWithClassName:(NSString *)className;
+ (NSArray *)getClassList;

+ (NSArray *)getCode:(HHClassModel *)model;
+ (NSArray *)getClassModelArr:(HHTreeNode*)node;
@end
