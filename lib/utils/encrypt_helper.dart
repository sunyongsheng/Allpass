import 'package:cipher2/cipher2.dart';

/// 加密解密辅助类
class EncryptHelper {
  static final String _key = "f821kfo1we241ew0";
  static final String _iv = "e4n8dol2390z834n";

  static Future<String> encrypt(String password) async {
    return await Cipher2.encryptAesCbc128Padding7(password, _key, _iv);
  }

  static Future<String> decrypt(String encryptTxt) async {
    return await Cipher2.decryptAesCbc128Padding7(encryptTxt, _key, _iv);
  }
}