class DecodeException implements Exception {}

class PreDecryptException implements Exception {}

class UnsupportedContentException implements Exception {}

class FallbackOldException implements Exception {
  final List<dynamic> data;

  FallbackOldException(this.data);
}
