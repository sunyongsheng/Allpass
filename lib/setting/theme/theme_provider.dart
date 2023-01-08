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
    lightTheme = _convertTheme(Config.primaryColor, false);
    darkTheme = _convertTheme(Config.primaryColor, true);
  }

  void changeThemeMode(ThemeMode targetMode, Brightness platformBrightness) {
    themeMode = targetMode;
    Config.setThemeMode(targetMode);
    setExtraColor(platformBrightness);
  }

  void changePrimaryColor(PrimaryColor color, Brightness platformBrightness) {
    lightTheme = _convertTheme(color, false);
    darkTheme = _convertTheme(color, true);
    Config.setPrimaryColor(color);
    setExtraColor(platformBrightness);
  }

  ThemeData _convertTheme(PrimaryColor color, bool dark) {
    switch (color) {
      case PrimaryColor.blue:
        return _allpassTheme.blueTheme(dark);
      case PrimaryColor.red:
        return _allpassTheme.redTheme(dark);
      case PrimaryColor.teal:
        return _allpassTheme.tealTheme(dark);
      case PrimaryColor.deepPurple:
        return _allpassTheme.deepPurpleTheme(dark);
      case PrimaryColor.orange:
        return _allpassTheme.orangeTheme(dark);
      case PrimaryColor.pink:
        return _allpassTheme.pinkTheme(dark);
      case PrimaryColor.blueGrey:
        return _allpassTheme.blueGreyTheme(dark);
      default:
        return _allpassTheme.blueTheme(dark);
    }
  }

  void setExtraColor(Brightness platformBrightness) {
    if (themeMode == ThemeMode.system) {
      _setExtraColorAuto(platformBrightness);
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

  void _setExtraColorAuto(Brightness platformBrightness) {
    if (platformBrightness == Brightness.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
  }
}
