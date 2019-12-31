import 'dart:io' show Platform, File, Directory;

import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/encrypt_helper.dart';
import 'package:allpass/utils/string_process.dart';

class CsvHelper {

  /// 将PasswordList导出为csv，[,]分隔，[\n]换行，返回文件路径
  Future<String> passwordExportCsv(List<PasswordBean> list, Directory dst) async {
    if (Platform.isAndroid) {
      String path = "${dst.path}/allpass_密码.csv";
      File csv = File(path);
      if (!csv.existsSync()) {
        csv.createSync();
      }
      String w = "name,username,password,url,folder,notes,label,fav\n";
      for (var item in list) {
        w += await PasswordBean.toCsv(item);
      }
      csv.writeAsStringSync(w);
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
      String w = "name,ownerName,cardId,url,telephone,folder,notes,label,fav\n";
      for (var item in list) {
        w += CardBean.toCsv(item);
      }
      csv.writeAsStringSync(w);
      return path;
    }
    return null;
  }

  /// 从csv文件中导入Password，返回List<PasswordBean>
  Future<List<PasswordBean>> passwordImportFromCsv({String path, String toParseText}) async {
    assert(path == null || toParseText == null, "只能传入一个参数！");
    List<PasswordBean> res = List();
    String fileContext;
    if (toParseText.length > 3) {
      fileContext = toParseText;
    } else {
      File file = File(path);
      if (!file.existsSync()) throw UnsupportedError("文件不存在!");
      fileContext = file.readAsStringSync();
    }
    List<String> text = fileContext.split("\n");
    if (text.length <= 1) return null;
    else {
      int nameIndex = -1;
      int usernameIndex = -1;
      int passwordIndex = -1;
      int urlIndex = -1;
      int folderIndex = -1;
      int notesIndex = -1;
      int labelIndex = -1;
      int favIndex = -1;
      List<String> index = text[0].split(",");
      for (int i = 0; i < index.length; i++) {
        switch (index[i]) {
          case "name":
            nameIndex = i;
            break;
          case "username":
            usernameIndex = i;
            break;
          case "password":
            passwordIndex = i;
            break;
          case "url":
            urlIndex = i;
            break;
          case "folder":
            folderIndex = i;
            break;
          case "notes":
            notesIndex = i;
            break;
          case "label":
            labelIndex = i;
            break;
          case "fav":
            favIndex = i;
            break;
        }
        // Chrome 生成的CSV格式password列需要以这种形式进行判断
        if (index[i].contains("password")) {
          passwordIndex = i;
        }
      }
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = List();
        String name = "";
        String username = "";
        String password = "";
        String url = "";
        String folder = "默认";
        String notes = "";
        int fav = 0;
        if (nameIndex != -1) {
          name = attribute[nameIndex] == null ? "" : attribute[nameIndex];
        }
        if (usernameIndex != -1) {
          username = attribute[usernameIndex] == null ? "" : attribute[usernameIndex];
        }
        if (passwordIndex != -1) {
          password = attribute[passwordIndex] == null ? "" : attribute[passwordIndex];
        }
        if (urlIndex != -1) {
          url = attribute[urlIndex] == null ? "" : attribute[urlIndex];
        }
        if (folderIndex != -1) {
          folder = attribute[folderIndex] == null ? "默认" : attribute[folderIndex];
        }
        if (notesIndex != -1) {
          notes = attribute[notesIndex] == null ? "" : attribute[notesIndex];
        }
        if (labelIndex != -1) {
          if (attribute[labelIndex].length > 0) {
            label = str2List(attribute[labelIndex]);
          }
        }
        if (favIndex != -1) {
          fav = int.parse(attribute[favIndex] == null ? "0" : attribute[favIndex]);
        }
        res.add(PasswordBean(
          name: name,
          username: username,
          password: await EncryptHelper.encrypt(password),
          url: url,
          folder: folder,
          notes: notes,
          label: label,
          fav: fav,
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
      int nameIndex = -1;
      int ownerNameIndex = -1;
      int cardIdIndex = -1;
      int telephoneIndex = -1;
      int urlIndex = -1;
      int folderIndex = -1;
      int notesIndex = -1;
      int labelIndex = -1;
      int favIndex = -1;
      List<String> index = text[0].split(",");
      for (int i = 0; i < index.length; i++) {
        switch (index[i]) {
          case "name":
            nameIndex = i;
            break;
          case "ownerName":
            ownerNameIndex = i;
            break;
          case "cardId":
            cardIdIndex = i;
            break;
          case "url":
            urlIndex = i;
            break;
          case "telephone":
            telephoneIndex = i;
            break;
          case "folder":
            folderIndex = i;
            break;
          case "notes":
            notesIndex = i;
            break;
          case "label":
            labelIndex = i;
            break;
          case "fav":
            favIndex = i;
            break;
        }
      }
      // 对接下来的每一行
      for (var item in text.sublist(1)) {
        List<String> attribute = item.split(",");
        if (attribute.length != index.length) continue;
        List<String> label = List();
        String name = "";
        String ownerName = "";
        String cardId = "";
        String url = "";
        String telephone = "";
        String folder = "默认";
        String notes = "";
        int fav = 0;
        if (nameIndex != -1) {
          name = attribute[nameIndex] == null ? "" : attribute[nameIndex];
        }
        if (ownerNameIndex != -1) {
          ownerName = attribute[ownerNameIndex] == null ? "" : attribute[ownerNameIndex];
        }
        if (cardIdIndex != -1) {
          cardId = attribute[cardIdIndex] == null ? "" : attribute[cardIdIndex];
        }
        if (urlIndex != -1) {
          url = attribute[urlIndex] == null ? "" : attribute[urlIndex];
        }
        if (telephoneIndex != -1) {
          telephone = attribute[telephoneIndex] == null ? "" : attribute[telephoneIndex];
        }
        if (folderIndex != -1) {
          folder = attribute[folderIndex] == null ? "默认" : attribute[folderIndex];
        }
        if (notesIndex != -1) {
          notes = attribute[notesIndex] == null ? "" : attribute[notesIndex];
        }
        if (labelIndex != -1) {
          if (attribute[labelIndex].length > 0) {
            label = str2List(attribute[labelIndex]);
          }
        }
        if (favIndex != -1) {
          fav = int.parse(attribute[favIndex] == null ? "0" : attribute[favIndex]);
        }
        res.add(CardBean(
          name: name,
          ownerName: ownerName,
          cardId: cardId,
          url: url,
          telephone: telephone,
          folder: folder,
          notes: notes,
          label: label,
          fav: fav,
        ));
      }
    }
    return res;
  }

}