/// 多条信息时, 单条的信息
class SingleAction {
  /// 标题
  final String title;

  /// 点击后的连接
  final String actionURL;

  /// 具体的参数信息查看字段说明
  const SingleAction({
    required this.title,
    required this.actionURL,
  });
}
