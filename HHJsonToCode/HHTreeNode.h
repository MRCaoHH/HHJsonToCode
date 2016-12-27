//
//  HHTreeNode.h
//  HHJsonToCode
//
//  Created by caohuihui on 2016/12/1.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HHTreeNode : NSTreeNode
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id objectValue;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *modification;
@property (nonatomic, assign) BOOL pointer;
@end
