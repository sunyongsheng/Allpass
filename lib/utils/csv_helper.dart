import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';

class CsvHelper {

  /// 将PasswordList导出为csv，[,]分隔，[\n]换行，返回文件路径
  Future<String> passwordExportCsv(List<PasswordBean> list) async {
    if (Platform.isAndroid) {
      Directory directory = await getExternalStorageDirectory();
      String path = "${directory.path}/password.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      String w = "name,username,password,url,folder,notes,label,fav\n";
      for (var item in list) {
        w += PasswordBean.passwordBean2Csv(item);
      }
      csv.writeAsStringSync(w);
      print("写入完成，路径：$path");
      return path;
    }
    return null;
  }

  /// 将CardList导出为csv，[,]分隔，[\n]换行，返回文件路径
  Future<String> cardExportCsv(List<CardBean> list) async {
    if (Platform.isAndroid) {
      Directory directory = await getExternalStorageDirectory();
      String path = "${directory.path}/card.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      String w = "name,ownerName,cardId,url,telephone,folder,notes,label,fav\n";
      for (var item in list) {
        w += CardBean.cardBean2Csv(item);
      }
      csv.writeAsStringSync(w);
      print("写入完成，路径：$path");
      return path;
    }
    return null;
  }

  /// 从csv文件中导入Password，返回List<PasswordBean>
  Future<List<PasswordBean>> passwordImportFromCsv(String path) async {
    List<PasswordBean> res = List();
    File file = File(path);
    if (!file.existsSync()) throw UnsupportedError("文件不存在!");
    String fileContext = file.readAsStringSync();
    List<String> text = fileContext.split("\n");
    if (text.length <= 1) return null;
    else {
      assert(text[0] == "name,username,password,url,folder,notes,label,fav", "文件格式不正确！");
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != text[0].split(",").length) continue;
        List<String> label = List();
        if (attribute[6].length > 0) {
          for (String la in attribute[6].split("~")) {
            if (la != "" && la != " " && la != "~" && la != ",") label.add(la);
          }
        }
        res.add(PasswordBean(
          name: attribute[0] == null ? "" : attribute[0],
          username: attribute[1] == null ? "" : attribute[1],
          password: attribute[2] == null ? "" : attribute[2],
          url: attribute[3] == null ? "" : attribute[3],
          folder: attribute[4] == null ? "默认" : attribute[4],
          notes: attribute[5] == null ? "" : attribute[5],
          label: label,
          fav: int.parse(attribute[7]) == null ? "" : int.parse(attribute[7]),
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
      assert(text[0] == "name,ownerName,cardId,url,telephone,folder,notes,label,fav", "文件格式不正确！");
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != text[0].split(",").length) continue;
        List<String> label = List();
        if (attribute[7].length > 0) {
          for (String la in attribute[7].split("~")) {
            if (la != "" && la != " " && la != "~" && la != ",") label.add(la);
          }
        }
        res.add(CardBean(
          name: attribute[0] == null ? "" : attribute[0],
          ownerName: attribute[1] == null ? "" : attribute[1],
          cardId: attribute[2] == null ? "" : attribute[2],
          url: attribute[3] == null ? "" : attribute[3],
          telephone: attribute[4] == null ? "" : attribute[4],
          folder: attribute[5] == null ? "" : attribute[5],
          notes: attribute[6] == null ? "" : attribute[6],
          label: label,
          fav: int.parse(attribute[8]) == null ? 0 : int.parse(attribute[8]),
        ));
      }
    }
    return res;
  }

}