//
//  HHJsonToCodeTool.h
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kSeparatedString = @"\n---------------------------------------------\n";

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
+ (NSArray <HHCodeMode *>*)getCodeArr:(NSString *)codes;
+ (NSString *)getCodeDoc:(id)object className:(NSString *)className;
+ (NSString *)getCodeDocM:(NSString *)className;
+ (NSString *)getUserName;
+ (BOOL)checkIsJsonText:(NSString *)jsonText;
+ (id)objectWithJsonText:(NSString *)jsonText;
@end
