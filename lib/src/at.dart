/// @ 的人
class At {
  /// 根据电话号码来@
  final List<String> mobiles;

  /// 根据uid来@
  final List<String> userIds;

  /// @所有人
  final bool isAtAll;

  /// 都不是必填项
  ///
  /// 具体的查看每个参数的说明
  const At({
    this.mobiles = const [],
    this.userIds = const [],
    this.isAtAll = false,
  });

  /// 传输时使用
  Map<String, dynamic> toMap() {
    return {
      'atMobiles': mobiles,
      'atUserIds': userIds,
      'isAtAll': isAtAll,
    };
  }
}
