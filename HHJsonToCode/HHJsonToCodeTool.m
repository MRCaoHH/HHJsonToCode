//
//  HHJsonToCodeTool.m
//  HHJsonToCode
//
//  Created by caohuihui on 16/8/23.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHJsonToCodeTool.h"
#import "HHClassModel.h"
#import "HHTreeNode.h"
#import "HHPropertyModel.h"
#import "NSString+HHExtension.h"

static NSString *kFileName = @"___FILENAME___";
static NSString *kProjectName = @"___PROJECTNAME___";
static NSString *kDevName = @"___FULLUSERNAME___";
static NSString *kDate = @"___DATE___";
static NSString *kCopyright = @"___COPYRIGHT___";
static NSString *kImportXYExtension = @"#import <XYExtension/XYExtension.h>";
static NSString *kWriteCodeStart = @"+ (id)xy_replacedKeyFromPropertyName121:(NSString *)propertyName{\n\tNSString *newProertyName = propertyName;";
static NSString *kWriteCodeEnd = @"\n\treturn newProertyName;\n}";
static NSString *kWriteCodeFirstCharLow = @"\n\tnewProertyName = [newProertyName xy_firstCharUpper];";
static NSString *kWriteCodeRemoveUnline = @"\n\tnewProertyName = [newProertyName xy_underlineFromCamel];";
@implementation HHCodeMode

@end

@implementation HHJsonToCodeTool

+ (NSString *)getUserName{
    char *ch;
    char *path =  getwd(ch);
    NSString *str = [[NSString alloc]initWithUTF8String:path];
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    return arr[2];
}

+ (BOOL)checkIsJsonText:(NSString *)jsonText{
    if (jsonText.length == 0) {
        return NO;
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

+ (NSString *)modificationWithClassName:(NSString *)className{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HHPropertyHash" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *modifi = dic[className][kModification];
    return modifi?:(dic[@"Othe"][kModification]?:@"(nonatomic, strong)");
}

+ (BOOL)pointerWithClassName:(NSString *)className{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HHPropertyHash" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSNumber *pointer = dic[className][kPointer];
    return pointer?pointer.boolValue:[dic[@"Othe"][kPointer] integerValue];
}

+ (NSArray *)getClassList{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HHPropertyHash" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    return dic.allKeys;
}

+ (NSArray *)getCode:(HHClassModel *)model{
    return [self getCode:model firstCharLow:NO removeUnline:NO writeCode:NO];
}

+ (NSArray *)getCode:(HHClassModel *)model firstCharLow:(BOOL)firstCharLow removeUnline:(BOOL)removeUnline writeCode:(BOOL)writeCode{
    return @[[self getCodeH:model firstCharLow:firstCharLow removeUnline:removeUnline],[self getCodeM:model firstCharLow:firstCharLow removeUnline:removeUnline writeCode:writeCode]];
}

+ (HHCodeMode *)getCodeH:(HHClassModel *)model firstCharLow:(BOOL)firstCharLow removeUnline:(BOOL)removeUnline{
    NSMutableString *code = @"".mutableCopy;
    
    NSString *fileTemp = [self getFileTemp:[NSString stringWithFormat:@"%@.h",model.typeName]];
    [code appendString:fileTemp];
    
    NSMutableArray *impotClass = @[].mutableCopy;
    NSArray *defaultClass = [self getClassList];
    for (HHPropertyModel *proModel in model.proArr) {
        if (![defaultClass containsObject:proModel.typeName]) {
            [impotClass addObject:proModel.typeName];
        }
    }
    
    [code appendFormat:@"\n#import <Foundation/Foundation.h>\n"];
    
    for (NSString *aclass in impotClass) {
        [code appendFormat:@"\n@class %@;",aclass];
    }
    
    [code appendFormat:@"\n@interface %@ : NSObject\n",model.typeName];
    
    for (HHPropertyModel *proModel in model.proArr) {
        NSString *proertyName = proModel.name;
        if (firstCharLow) {
            proertyName = [proertyName xy_firstCharLower];
        }
        
        if (removeUnline) {
            proertyName = [proertyName xy_camelFromUnderline];
        }
        
        [code appendFormat:@"\n/**\n %@\n*/\n@property (%@) %@ %@%@;\n",proModel.note,proModel.modification,proModel.typeName,proModel.pointer?@"*":@"",proertyName];
    }
    
    [code appendFormat:@"\n@end"];
    HHCodeMode *codeModel = [[HHCodeMode alloc]init];
    codeModel.type = HHFileType_H;
    codeModel.className = model.typeName;
    codeModel.code = code;
    return codeModel;
}

+ (HHCodeMode *)getCodeM:(HHClassModel *)model firstCharLow:(BOOL)firstCharLow removeUnline:(BOOL)removeUnline  writeCode:(BOOL)writeCode{
    NSMutableString *code = @"".mutableCopy;
    
    NSString *fileTemp = [self getFileTemp:[NSString stringWithFormat:@"%@.m",model.typeName]];
    [code appendString:fileTemp];
    
    NSMutableArray *impotClass = @[].mutableCopy;
    NSArray *defaultClass = [self getClassList];
    for (HHPropertyModel *proModel in model.proArr) {
        if (![defaultClass containsObject:proModel.typeName]) {
            [impotClass addObject:proModel.typeName];
        }
    }
    
    [code appendFormat:@"\n#import \"%@.h\"\n",model.typeName];
    
    if (writeCode) {
        [code appendString:kImportXYExtension];
    }
    
    for (NSString *aclass in impotClass) {
        [code appendFormat:@"\n#import \"%@.h\" ",aclass];
    }
    
    
    [code appendFormat:@"\n@implementation %@\n",model.typeName];
    
    if (writeCode) {
        [code appendString:kWriteCodeStart];
    }
    
    if (writeCode && firstCharLow) {
        [code appendString:kWriteCodeFirstCharLow];
    }
    
    if (writeCode && removeUnline) {
        [code appendString:kWriteCodeRemoveUnline];
    }
    
    if (writeCode) {
        [code appendString:kWriteCodeEnd];
    }
    
    [code appendFormat:@"\n@end"];
    HHCodeMode *codeModel = [[HHCodeMode alloc]init];
    codeModel.type = HHFileType_M;
    codeModel.className = model.typeName;
    codeModel.code = code;
    return codeModel;
}

+ (NSString *)getFileTemp:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FileTemp" ofType:@"txt"];
    NSString *fileTemp = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",fileTemp);
    NSString *userName = [NSString stringWithCString:getlogin() encoding:NSUTF8StringEncoding];
    NSString *projectName = [NSString stringWithCString:getprogname() encoding:NSUTF8StringEncoding];
    NSDate *date =  [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yy/MM/dd";
    NSString *dateString  = [dateFormatter stringFromDate:date];
    dateFormatter.dateFormat = @"yyyy";
    NSString *copyrightString =  [NSString stringWithFormat:@"Copyright © %@年 %@. All rights reserved.",[dateFormatter stringFromDate:date],userName];
    fileTemp =  [fileTemp stringByReplacingOccurrencesOfString:kDate withString:dateString];
    fileTemp =  [fileTemp stringByReplacingOccurrencesOfString:kDevName withString:userName];
    fileTemp =  [fileTemp stringByReplacingOccurrencesOfString:kFileName withString:fileName];
    fileTemp =  [fileTemp stringByReplacingOccurrencesOfString:kCopyright withString:copyrightString];
    fileTemp = [fileTemp stringByReplacingOccurrencesOfString:kProjectName withString:projectName];
    return fileTemp;
}


+ (NSArray *)getClassModelArr:(HHTreeNode*)node{
    NSMutableArray *mutableArr = @[].mutableCopy;
    [self resolveNode:node classArr:mutableArr];
    
    NSMutableArray *classArr = @[].mutableCopy;
    NSMutableArray *defaultClass = [self getClassList].mutableCopy;
    for (HHClassModel *classModel in mutableArr) {
        if (![defaultClass containsObject:classModel.typeName]) {
            [classArr addObject:classModel];
            [defaultClass addObject:classModel.typeName];
        }
    }
    return classArr;
}

+ (void )resolveNode:(HHTreeNode*)node classArr:(NSMutableArray *)arr{
    HHClassModel *classModel = [[HHClassModel alloc]init];
    classModel.typeName = node.typeName;
    NSArray *defaultClass = [self getClassList];
    for (HHTreeNode *subNode in node.childNodes) {
        if (![defaultClass containsObject:subNode.typeName]||[subNode.childNodes count]) {
            [self resolveNode:subNode classArr:arr];
        }
        HHPropertyModel *propertyModel = [[HHPropertyModel alloc]init];
        propertyModel.name = subNode.name;
        propertyModel.note = [subNode.objectValue description];
        propertyModel.typeName = subNode.typeName;
        propertyModel.modification = subNode.modification;
        propertyModel.pointer = subNode.pointer;
        [classModel.proArr addObject:propertyModel];
    }
    
    [arr addObject:classModel];
}


@end
