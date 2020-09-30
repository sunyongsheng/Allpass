import 'dart:io';
import 'dart:convert';

import 'package:allpass/model/data/base_model.dart';
import 'package:allpass/model/data/card_bean.dart';
import 'package:allpass/model/data/password_bean.dart';
import 'package:allpass/param/config.dart';
import 'package:allpass/param/allpass_type.dart';

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
    if (list[0] is PasswordBean) {
      List<PasswordBean> passwords = List();
      for (PasswordBean bean in list) {
        passwords.add(PasswordBean.fromBean(bean, encryptLevel: Config.webDavEncryptLevel));
      }
      return json.encode(passwords);
    } else if (list[0] is CardBean){
      List<CardBean> cards = List();
      for (CardBean bean in list) {
        cards.add(CardBean.fromBean(bean, encryptLevel: Config.webDavEncryptLevel));
      }
      return json.encode(cards);
    }
    return json.encode(list);
  }

  /// 对json字符串[string]进行解码，返回List<PasswordBean>或List<CardBean>
  List<BaseModel> decodeList(String string, AllpassType type) {
    List<dynamic> decodedRes = json.decode(string);
    if (type == AllpassType.Password) {
      List<PasswordBean> results = List();
      for (var temp in decodedRes) {
        results.add(PasswordBean.fromJson(temp, encryptLevel: Config.webDavEncryptLevel));
      }
      return results;
    } else if (type == AllpassType.Card) {
      List<CardBean> results = List();
      for (var temp in decodedRes) {
        results.add(CardBean.fromJson(temp, encryptLevel: Config.webDavEncryptLevel));
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