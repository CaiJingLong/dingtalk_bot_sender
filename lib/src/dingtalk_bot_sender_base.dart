import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// 主类
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

  Future<void> sendMarkdown(String markdownText) async {
    final bodyMap = {
      'msgtype': 'markdown',
      'markdown': {
        'title': keyword,
        'text': markdownText,
      },
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

  Future<void> sendText(String text) async {
    final bodyMap = {
      'msgtype': 'text',
      'text': {
        'content': '$keyword $text',
      },
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
