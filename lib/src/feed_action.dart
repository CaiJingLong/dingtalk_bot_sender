/// 类似于微信消息的卡片
class FeedAction {
  /// 标题(文字部分)
  final String title;

  /// 消息的连接
  final String messageURL;

  /// 图片的url
  final String picURL;

  /// 参数查看字段的说明, 所有字段都是必填项
  const FeedAction({
    required this.title,
    required this.messageURL,
    required this.picURL,
  });
}
