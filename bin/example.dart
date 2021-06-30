import 'dart:convert';
import 'dart:io';

import 'package:dingtalk_bot_sender/dingtalk_bot_sender.dart';

/// 使用这个示例前, 复制 config-example.json, 改名为 config.json.
///
/// 并添加 hook_url keyword appsecret
Future<void> main(List<String> args) async {
  final src = 'config.json';
  final configFile = File(src);
  final configText = configFile.readAsStringSync();
  final map = json.decode(configText);
  final String hookUrl = map['hook_url'];
  final String? keyword = map['keyword'];
  final String? appsecret = map['appsecret'];

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
}
