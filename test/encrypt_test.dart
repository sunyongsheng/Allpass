import 'dart:convert';

import 'package:encrypt/encrypt.dart';

void main() {
  final key = Key.fromUtf8("6#MhbKXxU#4K1XGuvrVMWk3VLWu2*OGG");
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  String encrypted = encrypter.encrypt("1234567", iv: iv).base64;
  print(encrypted);
  String decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
  print(decrypted);
}