# 使用钉钉的机器人 API 发送消息

[官方文档][]

## 使用说明

```dart
final sender = DingTalkSender(
    hookUrl: hookUrl,
    keyword: keyword,
    appsecret: appsecret,
  );
  await sender.sendText('1');

  final markdown = '''
标题
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

引用
> A man who stands for nothing will fall for anything.

文字加粗、斜体
**bold**
*italic*

链接
[this is a link](http://name.com)

图片
![](http://name.com/pic.jpg)

无序列表
- item1
- item2

有序列表
1. item1
2. item2
  ''';
  await sender.sendMarkdown(markdown);
```

## LICENSE

Apache 2.0

[官方文档]: https://developers.dingtalk.com/document/app/custom-robot-access
