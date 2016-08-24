# HHJsonToCode

HHJsonToCode是一个将json文本转换成oc代码并生成文件的工具。
注意事项:请点击HHJsonToCode.xcodeproj打开工程，工程中有两个target，分别是：HHJsonToCode、HHJsonToCodePlugin.

HHJsonToCode 是以app形式运行。

HHJsonToCodePlugin 则是为xcode安装插件，打开方式菜单栏:Window->HHJsonToCode。运行成功后重启xcode，记住选择load bundle

版本v1.0
最初始的版本，只具备最基础的工能将json字符串转换成oc代码。在自动转换过程中非OC类型的属性设置是

`@property (nonatomic, assign) Type propertyName`

oc类型则是:

`@property (nonatomic, strong) Type *propertyName`

这是默认的。目前版本不支持自定义也不支持swift，以后的版本会陆续提供。

示例：
json:
```
{
  "name":"zhangSan",
  "age":41,
  "niceName":["张三","老张","张老头","三儿"],
  "sex":1,
  "spouse":{
    "name":"李四",
    "age":18,
    "sex":0
  },
  "son":[
    {
      "name":"王五",
      "age":5
    },
    {
      "name":"吴六",
      "age":6
    },
    {
      "name":"刘七",
      "age":7
    }
    ]
}
```

运行效果:


![](https://github.com/MRCaoHH/HHJsonToCode/blob/master/run1.png)


代码如下:

```
#import <Foundation/Foundation.h>

@interface spouse : NSObject

@property (nonatomic, strong) NSString *name; 
@property (nonatomic, assign) NSInteger age; 
@property (nonatomic, assign) NSInteger sex; 

@end
---------------------------------------------

#import "spouse.h"

@implementation spouse

@end
---------------------------------------------

#import <Foundation/Foundation.h>

@interface son : NSObject

@property (nonatomic, strong) NSString *name; 
@property (nonatomic, assign) NSInteger age; 

@end
---------------------------------------------

#import "son.h"

@implementation son

@end
---------------------------------------------

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic, assign) NSInteger age; 
@property (nonatomic, assign) NSInteger sex; 
@property (nonatomic, strong) spouse *spouse; 
@property (nonatomic, strong) NSString *name; 
@property (nonatomic, strong) NSArray *son; 
@property (nonatomic, strong) NSArray *niceName; 

@end
---------------------------------------------

#import "Data.h"

@implementation Data

@end
```

点击create file 会弹出视图选择储存文件的地点。
