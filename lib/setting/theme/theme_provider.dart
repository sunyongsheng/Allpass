import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/setting/theme/theme_resource.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  AppTheme(this.lightTheme, this.darkTheme, this.themeMode);
}

class ThemeProvider with ChangeNotifier {
  late AllpassTheme _allpassTheme;

  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _themeMode;

  AppTheme get appTheme => AppTheme(_lightTheme, _darkTheme, _themeMode);

  /// 特殊的背景颜色
  /// 少部分页面背景颜色为浅白色
  late Color specialBackgroundColor;
  late Color offstageColor;
  late Color successContentColor;
  late Color successBackgroundColor;
  late Color infoContentColor;
  late Color infoBackgroundColor;
  late Color warningContentColor;
  late Color waringBackgroundColor;
  late Color errorContentColor;
  late Color errorBackgroundColor;
  late Color iconColor;

  void init() {
    _allpassTheme = AllpassTheme();
    _themeMode = Config.themeMode;
    _lightTheme = _convertTheme(Config.primaryColor, false);
    _darkTheme = _convertTheme(Config.primaryColor, true);
  }

  void changeThemeMode(ThemeMode targetMode, Brightness platformBrightness) {
    _themeMode = targetMode;
    Config.setThemeMode(targetMode);
    setExtraColor(platformBrightness);
  }

  void changePrimaryColor(PrimaryColor color, Brightness platformBrightness) {
    _lightTheme = _convertTheme(color, false);
    _darkTheme = _convertTheme(color, true);
    Config.setPrimaryColor(color);
    setExtraColor(platformBrightness);
  }

  ThemeData _convertTheme(PrimaryColor color, bool dark) {
    return switch (color) {
      PrimaryColor.blue => _allpassTheme.blueTheme(dark),
      PrimaryColor.red => _allpassTheme.redTheme(dark),
      PrimaryColor.teal => _allpassTheme.tealTheme(dark),
      PrimaryColor.deepPurple => _allpassTheme.deepPurpleTheme(dark),
      PrimaryColor.orange => _allpassTheme.orangeTheme(dark),
      PrimaryColor.pink => _allpassTheme.pinkTheme(dark),
      PrimaryColor.blueGrey => _allpassTheme.blueGreyTheme(dark),
    };
  }

  void setExtraColor(Brightness platformBrightness) {
    if (_themeMode == ThemeMode.system) {
      _setExtraColorAuto(platformBrightness);
    } else if (_themeMode == ThemeMode.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
    notifyListeners();
  }

  void _setExtraColorLightMode() {
    specialBackgroundColor = Color.fromRGBO(245, 246, 250, 1);
    offstageColor = Colors.black87;
    successContentColor = Color(0xFF3B7055);
    successBackgroundColor = Color(0xFFEDFBF3);
    infoContentColor = Color(0xFF307185);
    infoBackgroundColor = Color(0xFFF1FBFE);
    warningContentColor = Color(0xFF81642E);
    waringBackgroundColor = Color(0xFFFFF9EC);
    errorContentColor = Color(0xFFAC2F52);
    errorBackgroundColor = Color(0xFFFFF1F6);
    iconColor = Color(0xFF81879F);
  }

  void _setExtraColorDarkMode() {
    specialBackgroundColor = Colors.black;
    offstageColor = Colors.grey[600]!;
    successContentColor = Color(0xFF69C28D);
    successBackgroundColor = Color(0xFF181818);
    infoContentColor = Color(0xFF25ABFB);
    infoBackgroundColor = Color(0xFF181818);
    warningContentColor = Color(0xFFFEBF4D);
    waringBackgroundColor = Color(0xFF181818);
    errorContentColor = Color(0xFFE2496F);
    errorBackgroundColor = Color(0xFF181818);
    iconColor = Color(0xFF8F8F8F);
  }

  void _setExtraColorAuto(Brightness platformBrightness) {
    if (platformBrightness == Brightness.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
  }
}
