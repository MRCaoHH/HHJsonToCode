# HHJsonToCode

HHJsonToCode是一个将json文本转换成oc代码并生成文件的工具。
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

