import 'dart:collection';
import 'dart:io' show Platform, File, Directory;

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/string_util.dart';

class CsvUtil {

  /// 将PasswordList导出为csv，[,]分隔，[\n]换行，返回文件路径
  Future<String> passwordExportCsv(List<PasswordBean> list, Directory dst) async {
    if (Platform.isAndroid) {
      String path = "${dst.path}/allpass_密码.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      csv.writeAsStringSync(await StringUtil.csvList2Str(list));
      return path;
    }
    return null;
  }

  /// 将CardList导出为csv，[,]分隔，[\n]换行，返回文件路径
  Future<String> cardExportCsv(List<CardBean> list, Directory dst) async {
    if (Platform.isAndroid) {
      String path = "${dst.path}/allpass_卡片.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      csv.writeAsStringSync(await StringUtil.csvList2Str(list));
      return path;
    }
    return null;
  }

  /// 从csv文件中导入Password，返回List<PasswordBean>
  Future<List<PasswordBean>> passwordImportFromCsv({String path, String toParseText}) async {
    assert(path == null || toParseText == null, "只能传入一个参数！");
    List<PasswordBean> res = List();
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
      Map<String, int> indexMap = findIndex(index);
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = List();
        String name = getValueWithCatch(attribute, indexMap, 'name');
        String username = getValueWithCatch(attribute, indexMap, 'username');
        String password = getValueWithCatch(attribute, indexMap, 'password');
        String url = getValueWithCatch(attribute, indexMap, 'url');
        String folder = getValueWithCatch(attribute, indexMap, 'folder');
        String notes = getValueWithCatch(attribute, indexMap, 'notes');
        if (indexMap.containsKey('label') && attribute[indexMap['label']].length > 0) {
          label = StringUtil.waveLineSegStr2List(getValueWithCatch(attribute, indexMap, 'label'));
        }
        int fav = int.parse(getValueWithCatch(attribute, indexMap, 'fav'));
        String createTime = getValueWithCatch(attribute, indexMap, "createTime");
        res.add(PasswordBean(
          name: name,
          username: username,
          password: EncryptUtil.encrypt(password),
          url: url,
          folder: folder,
          notes: notes,
          label: label,
          fav: fav,
          createTime: createTime
        ));
      }
    }
    return res;
  }

  /// 从csv文件中导入Card
  Future<List<CardBean>> cardImportFromCsv(String path) async {
    List<CardBean> res = List();
    File file = File(path);
    if (!file.existsSync()) throw UnsupportedError("文件不存在!");
    String fileContext = file.readAsStringSync();
    List<String> text = fileContext.split("\n");
    if (text.length <= 1) return null;
    else {
      List<String> index = text[0].split(",");
      Map<String, int> indexMap = findIndex(index);
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = List();
        String name = getValueWithCatch(attribute, indexMap, 'name');
        String ownerName = getValueWithCatch(attribute, indexMap, 'ownerName');
        String cardId = getValueWithCatch(attribute, indexMap, 'cardId');
        String password = getValueWithCatch(attribute, indexMap, 'password');
        String telephone = getValueWithCatch(attribute, indexMap, 'telephone');
        String folder = getValueWithCatch(attribute, indexMap, 'folder');
        String notes = getValueWithCatch(attribute, indexMap, 'notes');
        int fav = int.parse(getValueWithCatch(attribute, indexMap, 'fav'));
        if (indexMap.containsKey('label') && attribute[indexMap['label']].length > 0) {
          label = StringUtil.waveLineSegStr2List(getValueWithCatch(attribute, indexMap, 'label'));
        }
        String createTime = getValueWithCatch(attribute, indexMap, "createTime");
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
          createTime: createTime
        ));
      }
    }
    return res;
  }

  Map<String, int> findIndex(List<String> index) {
    Map<String, int> res = HashMap();
    for (int i = 0; i < index.length; i++) {
      res[index[i]] = i;
      if (index[i].contains('password')) {
        res['password'] = i;
      }
    }
    return res;
  }

  String getValueWithCatch(List<String> values, Map<String, int> indexMap, String mapKey) {
    try {
      if (indexMap.containsKey(mapKey)) return values[indexMap[mapKey]];
    } on RangeError {} catch (e) {}
    if (mapKey == "folder") return "默认";
    if (mapKey == 'fav') return '0';
    return "";
  }

}