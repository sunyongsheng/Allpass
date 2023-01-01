class UnsupportedArgumentException implements Exception {
  final String message;

  UnsupportedArgumentException(this.message);

  @override
  String toString() {
    return "UnsupportedArgumentError: $message";
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
