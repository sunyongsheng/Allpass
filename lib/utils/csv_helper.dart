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
      String w = "name,ownerName,cardId,url,telephone,folder,notes,label,fav\n";
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
      String w = "name,username,password,url,folder,notes,label,fav\n";
      for (var item in list) {
        w += CardBean.cardBean2Csv(item);
      }
      csv.writeAsStringSync(w);
      print("写入完成，路径：$path");
      return path;
    }
    return null;
  }

}