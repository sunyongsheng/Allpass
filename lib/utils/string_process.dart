import 'package:allpass/model/base_model.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';

/// 字符串处理

/// 将List转化为以[~]为分隔符的字符串
String list2WaveLineSegStr(List<String> list) {
  String res = "";
  for (var item in list) {
    res += item;
    if (item != list.last) res += "~";
  }
  return res;
}

/// 将以[~]为分隔符的字符串转化为List
List<String> waveLineSegStr2List(String string) {
  List<String> res = List();
  List<String> list = string.split("~");
  if (list != null) {
    for (var item in list) {
      if (item != "" && item != "," && item != " " && item != "~") res.add(item);
    }
  }
  return res;
}

/// 将List中的字符串直接拼接为一个字符串
String list2PureStr(List<String> list) {
  StringBuffer stringBuffer = StringBuffer();
  for (String string in list??List()) {
    stringBuffer.write(string);
  }
  return stringBuffer.toString();
}

/// 将csv格式的List转化为一个String
Future<String> csvList2Str(List<BaseModel> list) async {
  if (list[0] is PasswordBean) {
    StringBuffer w = StringBuffer("name,username,password,url,folder,notes,label,fav\n");
    for (var item in list) {
      w.write(await PasswordBean.toCsv(item));
    }
    return w.toString();
  } else if (list[0] is CardBean) {
    StringBuffer w = StringBuffer("name,ownerName,cardId,password,telephone,folder,notes,label,fav\n");
    for (var item in list) {
      w.write(CardBean.toCsv(item));
    }
    return w.toString();
  }
  return null;
}