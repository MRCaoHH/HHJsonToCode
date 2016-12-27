//
//  HHComboBoxCell.m
//  HHJsonToCode
//
//  Created by caohuihui on 2016/12/6.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHComboBoxCell.h"
#import "HHJsonToCodeTool.h"
#import "Masonry.h"

@interface HHComboBoxCell ()<NSComboBoxCellDataSource>
{
    NSComboBoxCell *_cell;
}
@end

@implementation HHComboBoxCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.type = NSTextCellType;
    self.usesDataSource = YES;
    self.dataSource = self;
    self.numberOfVisibleItems = 5;
    self.buttonBordered = NO;
    NSText *text = [[NSText alloc]init];
    [self setUpFieldEditorAttributes:text];
}

//- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp{
//    NSLog(@"11111111");
//    return YES;
//}

#pragma mark - NSComboBoxCellDataSource
- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell{
    return [HHJsonToCodeTool getClassList].count;
}

- (id)comboBoxCell:(NSComboBoxCell *)comboBoxCell objectValueForItemAtIndex:(NSInteger)index{
    self.selTitle = [HHJsonToCodeTool getClassList][index];
    return [HHJsonToCodeTool getClassList][index];
}

//- (NSUInteger)comboBoxCell:(NSComboBoxCell *)comboBoxCell indexOfItemWithStringValue:(NSString *)string{
//    return [[HHJsonToCodeTool getClassList] indexOfObject:string];
//}
//
//- (nullable NSString *)comboBoxCell:(NSComboBoxCell *)comboBoxCell completedString:(NSString *)uncompletedString{
//    return uncompletedString;
//}

@end
