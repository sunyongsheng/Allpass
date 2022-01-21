import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';

/// 字符串处理
class StringUtil {
  StringUtil._();

  /// 将List转化为以[~]为分隔符的字符串
  static String list2WaveLineSegStr(List<String>? list) {
    if (list == null) {
      return "";
    }
    String res = "";
    for (var item in list) {
      res += item;
      if (item != list.last) res += "~";
    }
    return res;
  }

  /// 将以[~]为分隔符的字符串转化为List
  static List<String> waveLineSegStr2List(String? string) {
    List<String> res = [];
    List<String>? list = string?.split("~");
    if (list != null) {
      for (var item in list) {
        if (item != "" && item != "," && item != " " && item != "~") res.add(item);
      }
    }
    return res;
  }

  /// 将List中的字符串直接拼接为一个字符串
  static String list2PureStr(List<String>? list) {
    StringBuffer stringBuffer = StringBuffer();
    for (String string in list ?? []) {
      stringBuffer.write(string);
    }
    return stringBuffer.toString();
  }

  /// 将csv格式的List转化为一个String
  static Future<String> csvList2Str(List<BaseModel> list) async {
    if (list[0] is PasswordBean) {
      StringBuffer w = StringBuffer("name,username,password,url,folder,notes,label,fav,createTime,sortNumber,appId\n");
      for (var item in list) {
        w.write(await PasswordBean.toCsv(item as PasswordBean));
      }
      return w.toString();
    } else if (list[0] is CardBean) {
      StringBuffer w = StringBuffer("name,ownerName,cardId,password,telephone,folder,notes,label,fav,createTime,sortNumber\n");
      for (var item in list) {
        w.write(CardBean.toCsv(item as CardBean));
      }
      return w.toString();
    }
    return "";
  }
}