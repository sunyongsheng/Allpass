import 'package:flutter/material.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/ui/theme_resource.dart';

class ThemeProvider with ChangeNotifier {
  AllpassTheme _allpassTheme;

  ThemeData currTheme;
  Color offsetColor;
  /// 首字母索引
  /// 当某条记录包含此首字母时显示的颜色，在深色主题下是白色，在浅色主题下是黑色
  Color containColor;
  /// 特殊的背景颜色
  /// 少部分页面背景颜色为浅白色
  Color specialBackgroundColor;

  init() {
    _allpassTheme = AllpassTheme();
    currTheme = getTheme(Config.theme);
  }

  void changeTheme(String themeName) {
    if (themeName == Config.theme) return;
    currTheme = getTheme(themeName);
    Config.setTheme(themeName);
    notifyListeners();
  }

  ThemeData getTheme(String themeName) {
    if (themeName == "dark") {
      offsetColor = Colors.grey;
      containColor = Colors.white;
      specialBackgroundColor = Colors.black;
    } else {
      offsetColor = Colors.black87;
      containColor = Colors.black;
      specialBackgroundColor = Color.fromRGBO(245, 246, 250, 1);
    }
    switch (themeName) {
      case "blue":
        return _allpassTheme.blueTheme();
      case "red":
        return _allpassTheme.redTheme();
      case "teal":
        return _allpassTheme.tealTheme();
      case "deepPurple":
        return _allpassTheme.deepPurpleTheme();
      case "orange":
        return _allpassTheme.orangeTheme();
      case "pink":
        return _allpassTheme.pinkTheme();
      case "blueGrey":
        return _allpassTheme.blueGreyTheme();
      case "dark":
        return _allpassTheme.darkTheme();
      default:
        return _allpassTheme.blueTheme();
    }
  }
}