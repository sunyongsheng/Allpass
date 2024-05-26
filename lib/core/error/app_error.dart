/// 不支持的枚举类型
class UnsupportedEnumException implements Exception {
  final String message;

  UnsupportedEnumException(this.message);

  @override
  String toString() {
    return "UnsupportedEnumException: $message";
  }
}

class UnknownException implements Exception {
  final String? message;

  UnknownException(this.message);

  @override
  String toString() {
    return "UnknownError: $message";
  }
}

class UnsupportedArgumentException implements Exception {
  final String message;

  UnsupportedArgumentException(this.message);

  @override
  String toString() {
    return "UnsupportedArgumentException: $message";
  }
}
