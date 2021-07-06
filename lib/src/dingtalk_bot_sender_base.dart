import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'at.dart';
import 'feed_action.dart';
import 'single_action.dart';

/// 发送的主类, 主要目的就是可以使用钉钉的机器人发送消息到群里
///
/// 关于消息类型可以查看[文档](https://developers.dingtalk.com/document/app/custom-robot-access/title-72m-8ag-pqw)
///
/// 使用示例如下
///
/// 为简单, 就使用关键字字段, 如果有加签需求, 则传入 appsecret
///
/// ```dart
///
///   final sender = DingTalkSender(
///     hookUrl: hookUrl,
///     keyword: keyword,
///     appsecret: appsecret,
///   );
///
///   final at = At(isAtAll: true);
///
///   await sender.sendText('1', at: at);
///
///   final markdown = '''
/// 标题
/// # 一级标题
/// ## 二级标题
/// ### 三级标题
/// #### 四级标题
/// ##### 五级标题
/// ###### 六级标题
///
/// 引用
/// > A man who stands for nothing will fall for anything.
///
/// 文字加粗、斜体
/// **bold**
/// *italic*
///
/// 链接
/// [this is a link](http://name.com)
///
/// 图片
/// ![](http://name.com/pic.jpg)
///
/// 无序列表
/// - item1
/// - item2
///
/// 有序列表
/// 1. item1
/// 2. item2
///   ''';
///
///   final at2 = At(userIds: ['manager5664']);
///   await sender.sendMarkdown(markdown, at: at2);
/// ```
class DingTalkSender {
  /// webhook url
  final String hookUrl;

  /// 关键字, 在软件的机器人里配置
  final List<String> keywords;

  /// 加签, 有需求就传入
  final String? appsecret;

  /// [hookUrl] 是必须的, 其他都不是必须的, 但需要跟着
  DingTalkSender({
    required this.hookUrl,
    this.keywords = const [],
    this.appsecret,
  });

  String _sign() {
    if (appsecret != null) {
      final secret = appsecret!;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final key = utf8.encode(secret);
      final bytes = utf8.encode('$timestamp\n$secret');
      final hmac = Hmac(sha256, key);
      final result = hmac.convert(bytes).bytes;
      final sign = base64.encode(result);

      return '&timestamp=$timestamp&sign=$sign';
    }
    return '';
  }

  Uri _makeUri() {
    return Uri.parse('$hookUrl${_sign()}');
  }

  void _assertKeyword(String text) {
    if (keywords.isEmpty) {
      return;
    }

    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        // 有关键字
        return;
      }
    }

    assert(false, '$text 中不包含关键字: $keywords');
  }

  Future<void> _sendWithMap(Map bodyMap) async {
    final response = await http.post(
      _makeUri(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyMap),
      encoding: utf8,
    );

    print(response.body);
  }

  /// 发送纯文本
  Future<void> sendText(String text, {At? at}) async {
    _assertKeyword(text);
    final bodyMap = {
      'msgtype': 'text',
      'text': {
        'content': text,
      },
      'at': at?.toMap() ?? {},
    };

    await _sendWithMap(bodyMap);
  }

  /// 发送 markdown 文本
  Future<void> sendMarkdown({
    required String title,
    required String markdownText,
    At? at,
  }) async {
    final bodyMap = {
      'msgtype': 'markdown',
      'markdown': {
        'title': title,
        'text': markdownText,
      },
      'at': at?.toMap() ?? {},
    };

    await _sendWithMap(bodyMap);
  }

  /// 发送链接型
  Future<void> sendLink({
    required String title,
    required String text,
    required String messageUrl,
    String? picUrl,
  }) async {
    _assertKeyword(text);
    final bodyMap = {
      'msgtype': 'link',
      'link': {
        'title': title,
        'text': text,
        'messageUrl': messageUrl,
        'picUrl': picUrl ?? '',
      }
    };

    await _sendWithMap(bodyMap);
  }

  /// 整体的卡片式
  Future<void> sendSingleActionCard({
    required String title,
    required String text,
    required String singleTitle,
    required String singleURL,
    String? btnOrientation,
  }) async {
    final bodyMap = {
      'msgtype': 'actionCard',
      'actionCard': {
        'title': title,
        'text': text,
        'btnOrientation': btnOrientation ?? '0',
        'singleTitle': singleTitle,
        'singleURL': singleURL,
      },
    };
    await _sendWithMap(bodyMap);
  }

  /// 多按钮的卡片式
  Future<void> sendMultiActionCard({
    required String title,
    required String text,
    List<SingleAction> btns = const [],
    String? btnOrientation = '0',
  }) async {
    final bodyMap = {
      'msgtype': 'actionCard',
      'actionCard': {
        'title': title,
        'text': text,
        'btnOrientation': btnOrientation ?? '0',
        'btns': btns
            .map((e) => {
                  'title': e.title,
                  'actionURL': e.actionURL,
                })
            .toList(),
      },
    };

    await _sendWithMap(bodyMap);
  }

  /// 发送 FeedCard 类型
  Future<void> sendFeedCard({
    List<FeedAction> actions = const [],
  }) async {
    final bodyMap = {
      'msgtype': 'feedCard',
      'feedCard': {
        'links': actions
            .map((e) => {
                  'title': e.title,
                  'messageURL': e.messageURL,
                  'picURL': e.picURL,
                })
            .toList(),
      },
    };

    await _sendWithMap(bodyMap);
  }
}
