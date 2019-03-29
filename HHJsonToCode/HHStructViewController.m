//
//  HHStructViewController.m
//  HHJsonToCode
//
//  Created by caohuihui on 2016/11/28.
//  Copyright © 2016年 caohuihi. All rights reserved.
//

#import "HHStructViewController.h"
#import "AppDelegate.h"
#import "HHTreeNode.h"
#import "HHJsonToCodeTool.h"
#import "HHComboBoxCell.h"
#import "HHClassModel.h"

typedef NS_ENUM(NSInteger,HHColumnType) {
    HHColumnType_Name = 0,
    HHColumnType_Type = 1,
    HHColumnType_Pointer = 2,
    HHColumnType_Modification = 3,
    HHColumnType_Note = 4,
};

@interface HHStructViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource,NSComboBoxCellDataSource,NSTextDelegate>
{
    NSDictionary *_object;
    HHTreeNode *_rootNode;
}
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSTextField *classTextField;
@property (weak) IBOutlet NSButton *firstBtn;
@property (weak) IBOutlet NSButton *unlineBtn;
@property (weak) IBOutlet NSButton *writeCodeBtn;
@end

@implementation HHStructViewController
///属性首字母小写
static NSString *kFirstKey = @"first";
///下划线转换
static NSString *kUnlineKey = @"unline";
///写入转换代码
static NSString *kWriteKey = @"write";

- (void)viewDidLoad {
    [super viewDidLoad];

    NSData *data = [self.json dataUsingEncoding:NSUTF8StringEncoding];
    _object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _rootNode = [[HHTreeNode alloc]initWithRepresentedObject:_object];
    [self resolveId:_object note:_rootNode];
    [_outlineView  reloadItem:_rootNode];
    [_outlineView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:NSTextDidChangeNotification object:nil];
    ///
    BOOL first =  [[NSUserDefaults standardUserDefaults]boolForKey:kFirstKey];
    self.firstBtn.state = first?NSControlStateValueOn:NSControlStateValueOff;
    
    BOOL unline =  [[NSUserDefaults standardUserDefaults]boolForKey:kUnlineKey];
    self.unlineBtn.state = unline?NSControlStateValueOn:NSControlStateValueOff;
    
    BOOL write =  [[NSUserDefaults standardUserDefaults]boolForKey:kWriteKey];
    self.writeCodeBtn.state = write?NSControlStateValueOn:NSControlStateValueOff;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)notification{
    HHTreeNode *treeNode = [_outlineView itemAtRow:[_outlineView selectedRow]];
    NSTextView *textView = notification.object;
    switch ([_outlineView editedColumn]) {
        case HHColumnType_Name:
            treeNode.name = [textView.string copy];
            break;
        case HHColumnType_Type:
            treeNode.typeName = [textView.string copy];
            break;
        case HHColumnType_Modification:
            treeNode.modification = [textView.string copy];
            break;
        case HHColumnType_Note:
            treeNode.objectValue = [textView.string copy];
            break;
        default:
            break;
    }
    
    NSLog(@"%@",textView.string);
}

- (IBAction)clickPointerCheckBox:(id)sender {
    HHTreeNode *treeNode = [_outlineView itemAtRow:[_outlineView selectedRow]];
    treeNode.pointer = !treeNode.pointer;
}

- (void)resolveId:(id)object note:(HHTreeNode *)note{
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *arr = object;
        for (id sub in arr) {
            HHTreeNode *subNode = [[ HHTreeNode alloc]initWithRepresentedObject:sub];
            subNode.name = @"item";
            subNode.objectValue = sub;
            
            if ([sub isKindOfClass:[NSArray class]]) {
                subNode.typeName = @"NSArray";
                [self resolveId:sub note:subNode];
            }else if([sub isKindOfClass:[NSDictionary class]]){
                subNode.typeName = @"NSDictionary";
                [self resolveId:sub note:subNode];
            }else{
                subNode.typeName = @"NSString";
            }
            subNode.modification = [HHJsonToCodeTool modificationWithClassName:subNode.typeName];
            subNode.pointer = [HHJsonToCodeTool pointerWithClassName:subNode.typeName];
            [note.mutableChildNodes addObject:subNode];
        }
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = object;
        for (NSString *sub in dic.allKeys) {
            HHTreeNode *subNode = [[HHTreeNode alloc]initWithRepresentedObject:sub];
            subNode.name = sub;
            id subValue = dic[sub];
            subNode.objectValue = subValue;
            if ([subValue isKindOfClass:[NSArray class]]) {
                subNode.typeName = @"NSArray";
                [self resolveId:subValue note:subNode];
            }else if([subValue isKindOfClass:[NSDictionary class]]){
                subNode.typeName = @"NSDictionary";
                [self resolveId:subValue note:subNode];
            }else{
                subNode.typeName = @"NSString";
            }
            subNode.modification = [HHJsonToCodeTool modificationWithClassName:subNode.typeName];
            subNode.pointer = [HHJsonToCodeTool pointerWithClassName:subNode.typeName];
            [note.mutableChildNodes addObject:subNode];
        }
    }
    
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    HHTreeNode *note = item ?:_rootNode;
    return [note descendantNodeAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if(item == nil){
        return  [_rootNode.childNodes count];
    }
   HHTreeNode *note = item;
    return [note.childNodes count];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if(item == nil){
        return  [_rootNode.childNodes count];
    }
    HHTreeNode *note = item;
    return [note.childNodes count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    return YES;
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSString *ide = tableColumn.identifier;
    NSTextFieldCell *textCell =(NSTextFieldCell*)cell;
    HHTreeNode *treeNode = item;
    if ([ide isEqualToString:kName]) {
        textCell.stringValue = treeNode.name;
    }else if ([ide isEqualToString:kType]) {
        textCell.stringValue = treeNode.typeName;
    }else if ([ide isEqualToString:kModification]) {
        textCell.stringValue = treeNode.modification;
    }else if ([ide isEqualToString:kNote]) {
        textCell.stringValue = [treeNode.objectValue description];
    }else if ([ide isEqualToString:kPointer]) {
        NSButtonCell *btnCell = (NSButtonCell *)textCell;
        btnCell.state = treeNode.pointer;
    }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
    return 30;
}


- (IBAction)clickPreBtn:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate showJsonVc];
}

#pragma mark - NSComboBoxCellDataSource
- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell{
    return [HHJsonToCodeTool getClassList].count;
}

- (id)comboBoxCell:(NSComboBoxCell *)comboBoxCell objectValueForItemAtIndex:(NSInteger)index{
//    NSLog(@"%zd",[_outlineView selectedColumn]);
//    NSLog(@"%zd",[_outlineView selectedRow]);
    HHTreeNode *treeNode = [_outlineView itemAtRow:[_outlineView selectedRow]];
    treeNode.typeName = [HHJsonToCodeTool getClassList][index];
    return [HHJsonToCodeTool getClassList][index];
}

//- (NSUInteger)comboBoxCell:(NSComboBoxCell *)comboBoxCell indexOfItemWithStringValue:(NSString *)string{
//    return [[HHJsonToCodeTool getClassList] indexOfObject:string];
//}
//
//- (nullable NSString *)comboBoxCell:(NSComboBoxCell *)comboBoxCell completedString:(NSString *)uncompletedString{
//    return uncompletedString;
//}

- (IBAction)createObjectCCode:(id)sender {
    _rootNode.typeName = [_classTextField.stringValue length]?_classTextField.stringValue:@"HHModel";
    NSArray *arr =  [HHJsonToCodeTool getClassModelArr:_rootNode];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
//    [panel setDirectoryURL:[NSURL fileURLWithPath:@"~/Desktop/"]];
    typeof(self) weakSelf = self;
    
    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result) {
            [weakSelf saveAction:[panel URL].path classArr:arr];
        }
    }];
}

- (void)saveAction:(NSString *)path  classArr:(NSArray *)classArr{
    
    NSMutableArray *codeModelArr = @[].mutableCopy;
    for (HHClassModel *model in classArr) {
        
        NSArray *arr =  [HHJsonToCodeTool getCode:model firstCharLow:self.firstBtn.state == NSControlStateValueOn removeUnline:self.unlineBtn.state == NSControlStateValueOn writeCode:self.writeCodeBtn.state == NSControlStateValueOn];
        [codeModelArr addObjectsFromArray:arr];
    }
    
    for (HHCodeMode *model in codeModelArr) {
        [self saveFile:model suffix:0 path:path];
    }
    
    NSString *cmd = [NSString stringWithFormat:@"open %@",path];
    system([cmd UTF8String]);
}

- (void)saveFile:(HHCodeMode *)model suffix:(NSInteger )suffix path:(NSString *)path{
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@",model.className,({
        NSString *suffString = suffix ? [NSString stringWithFormat:@"(%zd)",suffix] : @"";
        suffString;
    }),({
        NSString *suffix = model.type ? @"m" :@"h";
        suffix;
    })];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self saveFile:model suffix:++suffix path:path];
        return;
    }
    [model.code writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)clickComboBox:(id)sender {
    HHTreeNode *treeNode = [_outlineView itemAtRow:[_outlineView selectedRow]];
    treeNode.modification = [HHJsonToCodeTool modificationWithClassName:treeNode.typeName];
    treeNode.pointer = [HHJsonToCodeTool pointerWithClassName:treeNode.typeName];
    [_outlineView reloadData];
}

#pragma mark -  -
- (IBAction)clickFirstBtn:(NSButton *)sender {
}
- (IBAction)clickUnlineBtn:(NSButton *)sender {
}
- (IBAction)clickWriteCodeBtn:(NSButton *)sender {
}

@end
