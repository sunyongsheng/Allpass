/// 反序列化文件内容失败
class DecodeException implements Exception {}

/// 预解密失败
class PreDecryptException implements Exception {}

/// 文件内容不是json类型
class UnsupportedContentException implements Exception {}
