import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/setting/theme/theme_resource.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late AllpassTheme _allpassTheme;

  late ThemeData lightTheme;
  late ThemeData darkTheme;
  late ThemeMode themeMode;

  /// 特殊的背景颜色
  /// 少部分页面背景颜色为浅白色
  late Color specialBackgroundColor;
  late Color offstageColor;

  init() {
    _allpassTheme = AllpassTheme();
    themeMode = Config.themeMode;
    lightTheme = _string2Theme(Config.lightTheme, false);
    darkTheme = _string2Theme(Config.lightTheme, true);
  }

  void changeThemeMode(ThemeMode targetMode, {required BuildContext context}) {
    themeMode = targetMode;
    Config.setThemeMode(targetMode);
    setExtraColor(context: context);
  }

  void changeLightTheme(PrimaryColor theme, {required BuildContext context}) {
    lightTheme = _string2Theme(theme.name, false);
    darkTheme = _string2Theme(theme.name, true);
    Config.setLightTheme(theme.name);
    setExtraColor(context: context);
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

  void setExtraColor({required BuildContext context, bool needReverse = false}) {
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
    offstageColor = Colors.black87;
  }

  void _setExtraColorDarkMode() {
    specialBackgroundColor = Colors.black;
    offstageColor = Colors.grey[600]!;
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
