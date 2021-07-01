class At {
  final List<String> mobiles;
  final List<String> userIds;
  final bool isAtAll;

  const At({
    this.mobiles = const [],
    this.userIds = const [],
    this.isAtAll = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'atMobiles': mobiles,
      'atUserIds': userIds,
      'isAtAll': isAtAll,
    };
  }
}
