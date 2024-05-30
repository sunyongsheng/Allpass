import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class Encryption {

  late Key _key;
  late IV _iv;
  late Encrypter _encrypt;

  Encryption(String encryptKey) {
    _key = Key.fromUtf8(encryptKey);
    // TODO secure random
    _iv = IV(Uint8List(16));
    _encrypt = Encrypter(AES(_key));
  }

  String encrypt(String text) {
    return _encrypt.encrypt(text, iv: _iv).base64;
  }

  String decrypt(String encryptTxt) {
    return _encrypt.decrypt(Encrypted.fromBase64(encryptTxt), iv: _iv);
  }
}