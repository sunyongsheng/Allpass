import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/encrypt/password_generator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 加密解密辅助类
class EncryptUtil {
  EncryptUtil._();

  static const String storeKey = "ALLPASS_SECURE_STORE_KEY";

  static String initialKey = "6#MhbKXxU#4K1XGuvrVMWk3VLWu2*OGG";

  static bool _haveInit = false;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static late Encryption? _encryption;

  static Future<String?> initEncrypt({bool needFresh = false}) async {
    String? keyStored = await _getStoreKey();
    if (needFresh) {
      keyStored = PasswordGenerator.generate(32);
      await _setStoreKey(keyStored);
    } else {
      if (keyStored == null) {
        keyStored = initialKey;
        await _setStoreKey(keyStored);
      } else {
        initialKey = keyStored;
      }
    }
    _encryption = Encryption(keyStored);
    _haveInit = true;
    if (needFresh) return keyStored;
    return null;
  }

  static Future<Null> initEncryptByKey(String key) async {
    assert(key.length == 32);
    await _setStoreKey(key);
    _encryption = Encryption(key);
    _haveInit = true;
  }

  static Future<String?> getStoreKey() async {
    return await _getStoreKey();
  }

  static Future<Null> clearEncrypt() async {
    final storage = _getSecureStorage();
    await storage.deleteAll();
    _encryption = null;
    _haveInit = false;
  }

  static Encryption getEncryption() {
    return _encryption!;
  }

  static String encrypt(String password) {
    if (!_haveInit) throw ArgumentError("请先调用initEncrypt函数");
    return _encryption!.encrypt(password);
  }

  static String decrypt(String encryptTxt) {
    if (!_haveInit) throw ArgumentError("请先调用initEncrypt函数");
    return _encryption!.decrypt(encryptTxt);
  }

  static FlutterSecureStorage _getSecureStorage() {
    return _storage;
  }

  static Future<String?> _getStoreKey() async {
    final storage = _getSecureStorage();
    return await storage.read(key: storeKey);
  }

  static Future<Null> _setStoreKey(String keyValue) async {
    final storage = _getSecureStorage();
    await storage.write(key: storeKey, value: keyValue);
  }
}
