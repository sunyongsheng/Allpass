import 'package:allpass/core/error/app_error.dart';

/// 存储app中的类型
enum AllpassType { password, card, other }

class AllpassTypes {
  static AllpassType parse(String type) {
    if (type == AllpassType.password.name) {
      return AllpassType.password;
    } else if (type == AllpassType.card.name) {
      return AllpassType.card;
    } else if (type == AllpassType.other.name) {
      return AllpassType.other;
    } else {
      throw UnsupportedEnumException("Unsupported type=$type");
    }
  }
}
