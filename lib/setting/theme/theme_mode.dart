import 'package:flutter/material.dart';

class ThemeModes {
  static ThemeMode? tryParse(String? name) {
    if (name == ThemeMode.light.name) {
      return ThemeMode.light;
    } else if (name == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else if (name == ThemeMode.system.name) {
      return ThemeMode.system;
    }

    return null;
  }
}

class ThemeModeItem {
  final ThemeMode mode;
  final String desc;

  const ThemeModeItem(this.mode, this.desc);
}

var themeModes = [
  const ThemeModeItem(ThemeMode.system, "跟随系统"),
  const ThemeModeItem(ThemeMode.light, "浅色"),
  const ThemeModeItem(ThemeMode.dark, "深色")
];

enum PrimaryColor {
  blue,
  red,
  teal,
  deepPurple,
  orange,
  pink,
  blueGrey
}

class PrimaryColors {
  static PrimaryColor? tryParse(String? name) {
    for (var color in PrimaryColor.values) {
      if (color.name == name) {
        return color;
      }
    }
    return null;
  }
}

class PrimaryColorItem {
  final PrimaryColor primaryColor;
  final String desc;
  final Color color;

  const PrimaryColorItem(this.primaryColor, this.desc, this.color);
}

var primaryColors = [
  const PrimaryColorItem(PrimaryColor.blue, "蓝色", Colors.blue),
  const PrimaryColorItem(PrimaryColor.red, "红色", Colors.red),
  const PrimaryColorItem(PrimaryColor.teal, "青色", Colors.teal),
  const PrimaryColorItem(PrimaryColor.deepPurple, "深紫", Colors.deepPurple),
  const PrimaryColorItem(PrimaryColor.orange, "橙色", Colors.orange),
  const PrimaryColorItem(PrimaryColor.pink, "粉色", Colors.pink),
  const PrimaryColorItem(PrimaryColor.blueGrey, "蓝灰", Colors.blueGrey),
];