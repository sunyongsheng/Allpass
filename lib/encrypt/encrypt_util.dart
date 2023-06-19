import 'dart:math';
import 'package:allpass/encrypt/encryption.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:allpass/core/param/constants.dart';

/// 加密解密辅助类
class EncryptUtil {

  EncryptUtil._();

  static String initialKey = "6#MhbKXxU#4K1XGuvrVMWk3VLWu2*OGG";

  static bool _haveInit = false;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static late Encryption? _encryption;

  static Future<String?> initEncrypt({bool needFresh = false}) async {
    String? keyStored = await _getStoreKey();
    if (needFresh) {
      keyStored = generateRandomKey(32);
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

  static String generateRandomKey(int len, {bool cap = true, bool low = true, bool number = true, bool sym = true}) {

    List<String> _capitalList = List.from(['D', 'E', 'F', 'G',
      'H', 'I', 'J', 'O', 'K', 'L', 'M', 'A', 'B', 'C', 'X', 'Y', 'N',
      'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'Z']);
    List<String> _lowCaseList = List.from(['a', 'v', 'w', 'f', 'g','x', 'm',
      'h', 'i', 'k', 'l', 'n', 'b', 'c', 'd', 'e', 'o', 'p', 'r', 'j',  's', 't', 'u',
      'y', 'q', 'z']);
    List<String> _numberList = List.from(['1', '9', '0', '2', '5', '6', '3', '4', '7', '8']);
    List<String> _symbolList = List.from(['!', '@', '*', '?', '#', '%', '~', '=']);
    List<String> list =[];
    if (cap && low && number && sym) {
      list.addAll(_lowCaseList);
      list.addAll(_capitalList);
      list.addAll(_symbolList);
      list.addAll(_numberList);
    } else if (cap && low && number && !sym) {
      list.addAll(_numberList);
      list.addAll(_capitalList);
      list.addAll(_lowCaseList);
    } else if (cap && low && !number && sym) {
      list.addAll(_capitalList);
      list.addAll(_symbolList);
      list.addAll(_lowCaseList);
    } else if (cap && !low && number && sym) {
      list.addAll(_numberList);
      list.addAll(_capitalList);
      list.addAll(_symbolList);
    } else if (!cap && low && number && sym) {
      list.addAll(_symbolList);
      list.addAll(_lowCaseList);
      list.addAll(_numberList);
    } else if (cap && low && !number && !sym) {
      list.addAll(_capitalList);
      list.addAll(_lowCaseList);
    } else if (cap && !low && number && !sym) {
      list.addAll(_numberList);
      list.addAll(_capitalList);
    } else if (cap && !low && !number && sym) {
      list.addAll(_symbolList);
      list.addAll(_capitalList);
    } else if (!cap && low && number && !sym) {
      list.addAll(_lowCaseList);
      list.addAll(_numberList);
    } else if (!cap && low && !number && sym) {
      list.addAll(_lowCaseList);
      list.addAll(_symbolList);
    } else if (!cap && !low && number && sym) {
      list.addAll(_numberList);
      list.addAll(_symbolList);
    } else if (cap && !low && !number && !sym) {
      list = _capitalList;
    } else if (!cap && low && !number && !sym) {
      list = _lowCaseList;
    } else if (!cap && !low && number && !sym) {
      list = _numberList;
    } else if (!cap && !low && !number && sym) {
      list = _symbolList;
    }
    StringBuffer stringBuffer = StringBuffer();
    Random random = Random.secure();
    for (int i = 0; i < len; i++) {
      int index = random.nextInt(list.length);
      stringBuffer.write(list[index]);
    }
    return stringBuffer.toString();
  }

  static FlutterSecureStorage _getSecureStorage() {
    return _storage;
  }

  static Future<String?> _getStoreKey() async {
    final storage = _getSecureStorage();
    return await storage.read(key: ExtraKeys.storeKey);
  }

  static Future<Null> _setStoreKey(String keyValue) async {
    final storage = _getSecureStorage();
    await storage.write(key: ExtraKeys.storeKey, value: keyValue);
  }

}
