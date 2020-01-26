import 'package:encrypt/encrypt.dart';

/// 加密解密辅助类
class EncryptUtil {
  static final _key = Key.fromUtf8("6#MhbKXxU#4K1XGuvrVMWk3VLWu2*OGG");
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String password) {
    return _encrypter.encrypt(password, iv: _iv).base64;
  }

  static String decrypt(String encryptTxt) {
    return _encrypter.decrypt(Encrypted.fromBase64(encryptTxt), iv: _iv);
  }
}