import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'at.dart';

/// 发送的主类, 主要目的就是可以使用钉钉的机器人发送消息到群里
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

  /// 关键字, 根据你的
  final String? keyword;
  final String? appsecret;

  DingTalkSender({
    required this.hookUrl,
    this.keyword = '',
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

  Uri _url() {
    return Uri.parse('$hookUrl${_sign()}');
  }

  /// 发送 markdown 文本
  Future<void> sendMarkdown(String markdownText, {At? at}) async {
    final bodyMap = {
      'msgtype': 'markdown',
      'markdown': {
        'title': keyword,
        'text': markdownText,
      },
      'at': at?.toMap() ?? {},
    };

    await http.post(
      _url(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyMap),
      encoding: utf8,
    );
  }

  /// 发送纯文本
  Future<void> sendText(String text, {At? at}) async {
    var content = text;

    if (keyword != null) {
      if (!text.contains(keyword!)) {
        content = '$keyword $content';
      }
    }

    final bodyMap = {
      'msgtype': 'text',
      'text': {
        'content': content,
      },
      'at': at?.toMap() ?? {},
    };

    final response = await http.post(
      _url(),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyMap),
      encoding: utf8,
    );

    print(response.body);
  }
}
