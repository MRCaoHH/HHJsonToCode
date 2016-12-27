//
//  HHClassModel.h
//  HHJsonToCode
//
//  Created by caohuihui on 2016/12/26.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHClassModel : NSObject
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong) NSMutableArray *proArr;
@end
