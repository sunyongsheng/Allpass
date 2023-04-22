import 'dart:collection';
import 'dart:io' show File, Directory;

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';
import 'package:flutter/cupertino.dart';

class ExportResult {

  final bool success;

  final String? path;

  final String? msg;

  ExportResult(this.success, this.path, this.msg);

  ExportResult.success(String path) : this(true, path, null);

  ExportResult.failed(String msg) : this(false, null, msg);
}

class CsvUtil {

  CsvUtil._();

  /// 将PasswordList导出为csv，[,]分隔，[\n]换行，返回文件路径
  static Future<ExportResult> passwordExportCsv(List<PasswordBean> list, Directory dst) async {
    try {
      String path = "${dst.path}/allpass_密码.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      csv.writeAsStringSync(await StringUtil.csvList2Str(list));
      return ExportResult.success(path);
    } catch (e) {
      debugPrint(e.toString());
      return ExportResult.failed(e.toString());
    }
  }

  /// 将CardList导出为csv，[,]分隔，[\n]换行，返回文件路径
  static Future<ExportResult> cardExportCsv(List<CardBean> list, Directory dst) async {
    try {
      String path = "${dst.path}/allpass_卡片.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      csv.writeAsStringSync(await StringUtil.csvList2Str(list));
      return ExportResult.success(path);
    } catch (e) {
      debugPrint(e.toString());
      return ExportResult.failed(e.toString());
    }
  }

  /// 从csv文件中导入Password，返回List<PasswordBean>
  static Future<List<PasswordBean>?> passwordImportFromCsv({String? path, String? toParseText}) async {
    assert(path == null || toParseText == null, "只能传入一个参数！");
    List<PasswordBean> res = [];
    String fileContext;
    if (toParseText != null) {
      fileContext = toParseText;
    } else if (path != null) {
      File file = File(path);
      if (!file.existsSync()) throw UnsupportedError("文件不存在!");
      fileContext = file.readAsStringSync();
    } else {
      throw Exception("传入参数为空！");
    }
    List<String> text = fileContext.split("\n");
    if (text.length <= 1) return null;
    else {
      List<String> index = text[0].split(",");
      Map<String, int> indexMap = _findIndexOf(index);
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = [];
        String name = _getValueWithCatch(attribute, indexMap, 'name');
        String username = _getValueWithCatch(attribute, indexMap, 'username');
        String password = _getValueWithCatch(attribute, indexMap, 'password');
        String url = _getValueWithCatch(attribute, indexMap, 'url');
        String folder = _getValueWithCatch(attribute, indexMap, 'folder');
        String notes = _getValueWithCatch(attribute, indexMap, 'notes');
        if (indexMap.containsKey('label') && attribute[indexMap['label']!].length > 0) {
          label = StringUtil.waveLineSegStr2List(_getValueWithCatch(attribute, indexMap, 'label'));
        }
        int fav = int.parse(_getValueWithCatch(attribute, indexMap, 'fav'));
        String createTime = _getValueWithCatch(attribute, indexMap, "createTime");
        int sortNumber = int.parse(_getValueWithCatch(attribute, indexMap, 'sortNumber'));
        String appId = _getValueWithCatch(attribute, indexMap, "appId");
        String appName = _getValueWithCatch(attribute, indexMap, "appName");
        res.add(PasswordBean(
          name: name,
          username: username,
          password: EncryptUtil.encrypt(password),
          url: url,
          folder: folder,
          notes: notes,
          label: label,
          fav: fav,
          createTime: createTime,
          sortNumber: sortNumber,
          appId: appId,
          appName: appName
        ));
      }
    }
    return res;
  }

  /// 从csv文件中导入Card
  static Future<List<CardBean>?> cardImportFromCsv(String path) async {
    List<CardBean> res = [];
    File file = File(path);
    if (!file.existsSync()) throw UnsupportedError("文件不存在!");
    String fileContext = file.readAsStringSync();
    List<String> text = fileContext.split("\n");
    if (text.length <= 1) return null;
    else {
      List<String> index = text[0].split(",");
      Map<String, int> indexMap = _findIndexOf(index);
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = [];
        String name = _getValueWithCatch(attribute, indexMap, 'name');
        String ownerName = _getValueWithCatch(attribute, indexMap, 'ownerName');
        String cardId = _getValueWithCatch(attribute, indexMap, 'cardId');
        String password = _getValueWithCatch(attribute, indexMap, 'password');
        String telephone = _getValueWithCatch(attribute, indexMap, 'telephone');
        String folder = _getValueWithCatch(attribute, indexMap, 'folder');
        String notes = _getValueWithCatch(attribute, indexMap, 'notes');
        int fav = int.parse(_getValueWithCatch(attribute, indexMap, 'fav'));
        if (indexMap.containsKey('label') && attribute[indexMap['label']!].length > 0) {
          label = StringUtil.waveLineSegStr2List(_getValueWithCatch(attribute, indexMap, 'label'));
        }
        String createTime = _getValueWithCatch(attribute, indexMap, "createTime");
        int sortNumber = int.parse(_getValueWithCatch(attribute, indexMap, 'sortNumber'));
        res.add(CardBean(
          name: name,
          ownerName: ownerName,
          cardId: cardId,
          password: EncryptUtil.encrypt(password),
          telephone: telephone,
          folder: folder,
          notes: notes,
          label: label,
          fav: fav,
          createTime: createTime,
          sortNumber: sortNumber
        ));
      }
    }
    return res;
  }

  static Map<String, int> _findIndexOf(List<String> index) {
    Map<String, int> res = HashMap();
    for (int i = 0; i < index.length; i++) {
      res[index[i]] = i;
      if (index[i].contains('password')) {
        res['password'] = i;
      }
    }
    return res;
  }

  static String _getValueWithCatch(List<String> values, Map<String, int> indexMap, String mapKey) {
    try {
      if (indexMap.containsKey(mapKey)) return values[indexMap[mapKey]!];
    } on RangeError {} catch (e) {}
    if (mapKey == "folder") return "默认";
    if (mapKey == 'fav') return '0';
    if (mapKey == 'sortNumber') return "-1";
    return "";
  }

}