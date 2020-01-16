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