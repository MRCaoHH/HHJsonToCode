//
//  HHClassModel.m
//  HHJsonToCode
//
//  Created by caohuihui on 2016/12/26.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHClassModel.h"

@implementation HHClassModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _proArr = @[].mutableCopy;
    }
    return self;
}

@end
