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

enum PrimaryColor {
  blue,
  red,
  teal,
  deepPurple,
  orange,
  pink,
  blueGrey;

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
