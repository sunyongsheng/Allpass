import 'dart:convert';
import 'dart:io';

import 'package:allpass/model/password_bean.dart';

class AllpassFileUtil {
  static const List<int> magicWord = [0x0, 0x8, 0x0, 0x3, 0xb, 0xa, 0xb, 0xe];

  bool formatCheck(File file) {
    List<int> _magicWord = file.readAsBytesSync();
    for (int i = 0, len = magicWord.length; i < len; i++) {
      if (magicWord[i] != _magicWord[i]) return false;
    }
    return true;
  }

  String read(String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException("文件不存在！", filePath);
    }
    if (formatCheck(file)) {
      return utf8.decode(file.readAsBytesSync().sublist(8));
    } else {
      throw FormatException("文件格式不合法！");
    }
  }

  void writeMagicWord(File file) {
    file.writeAsBytesSync(magicWord);
  }

  void write(String filePath, String content) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException("文件不存在！", filePath);
    }
    if (formatCheck(file)) {
      writeMagicWord(file); // 主要目的为了覆盖文件内容
      List<int> contents = utf8.encode(content);
      file.writeAsBytesSync(contents, mode: FileMode.append);
    } else {
      throw FormatException("文件格式不合法！");
    }
  }

}