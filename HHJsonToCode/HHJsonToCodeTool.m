//
//  HHJsonToCodeTool.m
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHJsonToCodeTool.h"

@implementation HHCodeMode

@end

@implementation HHJsonToCodeTool

+ (NSArray<HHCodeMode *> *)getCodeArr:(NSString *)codes{
    NSArray <NSString *> *codeArr = [codes componentsSeparatedByString:kSeparatedString];
    NSMutableArray *codeModels = @[].mutableCopy;
    for (NSString *code in codeArr) {
        HHCodeMode *codeModel = [[HHCodeMode alloc]init];
        codeModel.className = [self getClassName:code];
        codeModel.code = code;
        codeModel.type = [self getFileType:code];
        [codeModels addObject:codeModel];
    }
    return codeModels;
}

+ (HHFileType)getFileType:(NSString *)code{
    if ([code length] == 0) {
        return HHFileType_H;
    }
     NSRegularExpression * regularExpresion = [NSRegularExpression regularExpressionWithPattern:@"@implementation" options:NSRegularExpressionCaseInsensitive error:nil];
    
    if ([regularExpresion firstMatchInString:code options:NSMatchingReportProgress range:NSMakeRange(0, code.length)]) {
        return HHFileType_M;
    }
    return HHFileType_H;
}

+ (NSString *)getClassName:(NSString *)code{
    if ([code length] == 0) {
        return [NSString stringWithFormat:@"%zd",random()];
    }
    NSRegularExpression * regularExpresion = [NSRegularExpression regularExpressionWithPattern:@"(?<=((@implementation|@interface)[\\s]))(.*?)(?=[\\W])" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *matchResult =  [regularExpresion matchesInString:code options:NSMatchingReportProgress range:NSMakeRange(0, code.length)].lastObject;
    NSString *className = [code substringWithRange:matchResult.range];
    if (![className length]) {
        return [NSString stringWithFormat:@"%zd",random()];
    }
    return className;
}

+ (NSString *)getCodeDoc:(id)object className:(NSString *)className;{
    NSDictionary *dic = object;
    if ([object isKindOfClass:[NSArray class]]) {
        dic = ((NSArray *)object).firstObject;
    }
    NSMutableArray *code = @[].mutableCopy;
    [self getCodeWithDic:dic className:className codeArr:&code];
    return [code componentsJoinedByString:kSeparatedString];
}

+ (NSString *)getCodeDocM:(NSString *)className{
    return [NSString stringWithFormat:@"\n#import \"%@.h\"\n\n@implementation %@\n\n@end",className,className];
}

+ (NSString *)getUserName{
    char *ch;
    char *path =  getwd(ch);
    NSString *str = [[NSString alloc]initWithUTF8String:path];
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    return arr[2];
}

+ (BOOL)checkIsJsonText:(NSString *)jsonText{
    if (jsonText.length == 0) {
        return YES;
    }
    id object = [self objectWithJsonText:jsonText];
    return object != nil;
}

+ (id)objectWithJsonText:(NSString *)jsonText{
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return object;
}

+ (void)getCodeWithDic:(NSDictionary *)dic className:(NSString *)className codeArr:(NSMutableArray **)arr{
    NSMutableString *code = @"".mutableCopy;
    [code appendFormat:@"\n#import <Foundation/Foundation.h>\n\n@interface %@ : NSObject\n\n",className];
    for (NSString *key in [dic allKeys]) {
        id value = dic[key];
        if ([value isKindOfClass:[NSString class]]) {
            [code appendString:[self stringValue:key]];
        }else if ([value isKindOfClass:[NSNumber class]]){
            [code appendString:[self numberValue:key value:value]];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            [code appendString:[self dictionaryValue:key ]];
            [self getCodeWithDic:value className:key codeArr:arr];
        }else if ([value isKindOfClass:[NSArray class]]){
            [code appendString:[self arrayValue:key]];
            [self getCodeWithDic:value className:key codeArr:arr];
        }
    }
    [code appendString:@"\n@end"];
    
    
    if (![*arr containsObject:code]) {
        [*arr addObject:code];
    }
    
    NSString *codeM = [self getCodeDocM:className];
    if (![*arr containsObject:codeM]) {
        [*arr addObject:codeM];
    }
}

+ (NSString *)stringValue:(NSString *)key{
    return [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@; \n",key];
}

+ (NSString *)intValue:(NSString *)key{
    return [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@; \n",key];
}

+ (NSString *)doubleValue:(NSString *)key{
    return [NSString stringWithFormat:@"@property (nonatomic, assign) double %@; \n",key];
}

+ (NSString *)dictionaryValue:(NSString *)key{
    return [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@; \n",key,key];
}

+ (NSString *)arrayValue:(NSString *)key {
    return [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray <%@ *>*%@; \n",key,key];
}

+ (NSString *)numberValue:(NSString *)key value:(id)value{
    if ([value integerValue] == [value floatValue]) {
        return [self intValue:key];
    }else{
        return [self doubleValue:key];
    }
    
}

+ (NSString *)getFileHeader:(NSString *)fileName projectName:(NSString *)projectName organizationName:(NSString *)organizationName{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    NSString *userName = [self getUserName];
    return [NSString stringWithFormat:@"//\n//  %@\n//  %@\n//\n//  Created by %@ on %zd/%zd/%zd.\n//  Copyright © %zd年 %@. All rights reserved.\n//",fileName,projectName,userName,day,month,year,year,organizationName];
}

@end
