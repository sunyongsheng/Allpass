import 'package:flutter/material.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_resource.dart';

class ThemeProvider with ChangeNotifier {
  AllpassTheme _allpassTheme;

  ThemeData lightTheme;
  ThemeData darkTheme;
  ThemeMode themeMode;
  
  /// 特殊的背景颜色
  /// 少部分页面背景颜色为浅白色
  Color specialBackgroundColor;
  Color offsetColor;

  init() {
    _allpassTheme = AllpassTheme();
    themeMode = _string2ThemeMode(Config.themeMode);
    lightTheme = _string2Theme(Config.lightTheme, false);
    darkTheme = _string2Theme(Config.lightTheme, true);
  }

  void changeTheme(String themeName, {BuildContext context}) {
    if (themeMode == ThemeMode.light && themeName == Config.lightTheme) return;
    if (themeName == "dark") {
      _changeThemeMode(themeModeName: "dark");
    } else if (themeName == "system") {
      _changeThemeMode(themeModeName: "system");
    } else {
      _changeThemeMode();
      lightTheme = _string2Theme(themeName, false);
      darkTheme = _string2Theme(themeName, true);
      Config.setLightTheme(themeName);
    }
    setExtraColor(context: context);
  }

  void _changeThemeMode({String themeModeName = "light"}) {
    themeMode = _string2ThemeMode(themeModeName);
    Config.setThemeMode(themeModeName);
  }

  ThemeMode _string2ThemeMode(String themeMode) {
    switch (themeMode) {
      case "system":
        return ThemeMode.system;
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData _string2Theme(String themeName, bool dark) {
    switch (themeName) {
      case "blue":
        return _allpassTheme.blueTheme(dark);
      case "red":
        return _allpassTheme.redTheme(dark);
      case "teal":
        return _allpassTheme.tealTheme(dark);
      case "deepPurple":
        return _allpassTheme.deepPurpleTheme(dark);
      case "orange":
        return _allpassTheme.orangeTheme(dark);
      case "pink":
        return _allpassTheme.pinkTheme(dark);
      case "blueGrey":
        return _allpassTheme.blueGreyTheme(dark);
      default:
        return _allpassTheme.blueTheme(dark);
    }
  }
  
  void setExtraColor({BuildContext context, bool needReverse = false}) {
    if (themeMode == ThemeMode.system) {
      _setExtraColorAuto(context, reverse: needReverse);
    } else if (themeMode == ThemeMode.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
    notifyListeners();
  }

  void _setExtraColorLightMode() {
    specialBackgroundColor = Color.fromRGBO(245, 246, 250, 1);
    offsetColor = Colors.black87;
  }

  void _setExtraColorDarkMode() {
    specialBackgroundColor = Colors.black;
    offsetColor = Colors.grey[600];
  }

  void _setExtraColorAuto(BuildContext context, {bool reverse = false}) {
    Brightness reference = Brightness.dark;
    if (reverse) {
      reference = Brightness.light;
    }
    if (MediaQuery.platformBrightnessOf(context) == reference) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
  }
}