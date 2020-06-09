import 'dart:io';
import 'dart:convert';

import 'package:allpass/model/base_model.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/params/allpass_type.dart';

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
  List<BaseModel> decodeList(String string, AllpassType type) {
    List<dynamic> decodedRes = json.decode(string);
    if (type == AllpassType.PASSWORD) {
      List<PasswordBean> results = List();
      for (var temp in decodedRes) {
        results.add(PasswordBean.fromJson(temp));
      }
      return results;
    } else if (type == AllpassType.CARD) {
      List<CardBean> results = List();
      for (var temp in decodedRes) {
        results.add(CardBean.fromJson(temp));
      }
      return results;
    }
    return null;
  }

  /// 对[folderList]与[labelList]进行json编码
  String encodeFolderAndLabel(List<String> folderList, List<String> labelList) {
    return "{\"folder\": ${json.encode(folderList)}, \"label\": ${json.encode(labelList)}}";
  }

  /// 对[string]进行json解码，返回map
  Map<String, List<String>> decodeFolderAndLabel(String string) {
    var decoded = json.decode(string);
    Map<String, List<String>> res = Map();
    res['folder'] = List<String>();
    for (var item in decoded['folder']) {
      res['folder'].add(item.toString());
    }
    res['label'] = List<String>();
    for (var item in decoded['label']) {
      res['label'].add(item.toString());
    }
    return res;
  }

  /// 删除文件
  Future<Null> deleteFile(String filePath) async {
    File file = File(filePath);
    await file.delete();
  }
}