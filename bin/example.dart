import 'dart:convert';
import 'dart:io';

import 'package:dingtalk_bot_sender/dingtalk_bot_sender.dart';

late String keyword;

final String testURL = 'https://www.baidu.com/';

/// 使用这个示例前, 复制 config-example.json, 改名为 config.json.
///
/// 并添加 hook_url keyword appsecret
Future<void> main(List<String> args) async {
  // load config
  final src = 'config.json';
  final configFile = File(src);
  final configText = configFile.readAsStringSync();
  final map = json.decode(configText);
  final String hookUrl = map['hook_url'];
  keyword = map['keyword'];
  final String? appsecret = map['appsecret'];

  // new instance
  final sender = DingTalkSender(
    hookUrl: hookUrl,
    keywords: [keyword],
    appsecret: appsecret,
  );

  // await sendNormal(sender);
  // await sendLink(sender);
  // await sendActionCard(sender);
  await sendFeedCard(sender);
}

Future<void> sendFeedCard(DingTalkSender sender) async {
  await sender.sendFeedCard(actions: [
    FeedAction(
      title: '$keyword pub.dev',
      messageURL: 'https://pub.dev',
      picURL:
          'https://pub.flutter-io.cn/static/img/landing-01.png?hash=9uo48icpilbgptbl952ljslbcpbo0bh4',
    ),
    FeedAction(
      title: '$keyword 百度',
      messageURL: testURL,
      picURL:
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.guangyuanol.cn%2Fuploads%2Fallimg%2F140808%2F1-140pq0225w04.jpg&refer=http%3A%2F%2Fwww.guangyuanol.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1628140117&t=779e0dbe43c4ee846ffc94f2b26909d9',
    ),
  ]);
}

Future<void> sendActionCard(DingTalkSender sender) async {
  await sender.sendSingleActionCard(
    title: '标题',
    text: '$keyword 内容',
    singleTitle: '独立标题',
    singleURL: testURL,
  );

  await sender.sendMultiActionCard(
    title: '多action',
    text: '$keyword 内容',
    btns: [
      SingleAction(
        title: 'btn 1',
        actionURL: testURL,
      ),
      SingleAction(
        title: 'btn 2',
        actionURL: testURL,
      ),
    ],
  );
}

Future<void> sendLink(
  DingTalkSender sender,
) async {
  // send link
  await sender.sendLink(
    title: '百度',
    text: '$keyword 百度一下, 你就知道',
    messageUrl: testURL,
  );
}

Future<void> sendNormal(DingTalkSender sender) async {
  final at = At(isAtAll: true);

  // send text
  await sender.sendText('1', at: at);

  // send markdown
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

  final at2 = At(userIds: ['manager5664']);
  await sender.sendMarkdown(
    title: '$keyword 标题',
    markdownText: markdown,
    at: at2,
  );
}
