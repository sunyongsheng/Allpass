import 'dart:io';
import 'dart:convert';

import 'package:allpass/model/base_model.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';

class AllpassFileUtil {

  /// 读取路径为[filePath]的文件内容
  /// 若文件不存在则抛出异常
  /// 先进行格式检查，若格式正确则返回文件内容，否则抛出异常
  String readFile(String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException("文件不存在！", filePath);
    }
    return file.readAsStringSync();
  }

  /// 对路径为[filePath]的文件进行写入，[content]为写入内容
  /// 若文件不存在则抛出异常
  void writeFile(String filePath, String content) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException("文件不存在！", filePath);
    }
    file.writeAsStringSync(content, mode: FileMode.write);
  }

  /// 对[list]进行json编码
  String encodeList(List<BaseModel> list) {
    return json.encode(list);
  }

  /// 对json字符串[string]进行解码，返回List<PasswordBean>或List<CardBean>
  List<BaseModel> decodeList(String string) {
    List<dynamic> decodedRes = json.decode(string);
    try {
      List<PasswordBean> results = List();
      for (var temp in decodedRes) {
        results.add(PasswordBean.fromJson(temp));
      }
      return results;
    } catch (e) {
      List<CardBean> results = List();
      for (var temp in decodedRes) {
        results.add(CardBean.fromJson(temp));
      }
      return results;
    }
  }
}