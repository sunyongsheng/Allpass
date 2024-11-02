class FeedbackBean {

  /// 反馈内容
  String content;

  /// 联系方式
  String? contact;

  /// Allpass版本
  String? version;

  FeedbackBean({
    required this.content,
    this.contact,
    this.version,
  });

  Map<String, String?> toJson() {
    Map<String, String?> map = Map();
    map['feedbackContent'] = this.content;
    map['contact'] = this.contact;
    map['allpassVersion'] = this.version;
    return map;
  }
}