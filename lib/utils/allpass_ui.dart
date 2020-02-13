import 'dart:math';

import 'package:flutter/material.dart';

import 'package:allpass/utils/screen_util.dart';

/// 保存所有Allpass用到的文本样式
class AllpassTextUI {
  AllpassTextUI._();

  static final TextStyle titleBarStyle = TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5);

  static final TextStyle firstTitleStyleBlack =
      TextStyle(fontSize: 16, color: Colors.black);
  static final TextStyle secondTitleStyleBlack =
      TextStyle(fontSize: 14, color: Colors.black);

  static final TextStyle smallTextStyleBlack =
      TextStyle(fontSize: 12, color: Colors.black);
  static final TextStyle hintTextStyle =
      TextStyle(fontSize: 16, color: Colors.black54);
}

/// 保存所有Allpass用到的颜色
class AllpassColorUI {
  AllpassColorUI._();
  static final List<Color> allColor = List.of([
    Color.fromRGBO(8, 200, 224, 1),
    Color.fromRGBO(72, 120, 240, 1),
    Colors.amber,
    Colors.deepOrangeAccent,
    Colors.teal,
    Color.fromRGBO(52, 184, 105, 1),
    Color.fromRGBO(255, 86, 85, 1),
  ]);
}

/// 缩进样式
class AllpassEdgeInsets {
  AllpassEdgeInsets._();

  static EdgeInsets listInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(50),
    right: AllpassScreenUtil.setWidth(50),
  );

  static EdgeInsets dividerInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(70),
    right: AllpassScreenUtil.setWidth(70),
  );

  static EdgeInsets forViewCardInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(70),
    right: AllpassScreenUtil.setWidth(70),
    top: AllpassScreenUtil.setHeight(25),
    bottom: AllpassScreenUtil.setHeight(25),
  );

  static EdgeInsets forCardInset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(50),
      right: AllpassScreenUtil.setWidth(50),
      top: AllpassScreenUtil.setHeight(15),
      bottom: AllpassScreenUtil.setHeight(25));

  static EdgeInsets forSearchButtonInset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(50),
      right: AllpassScreenUtil.setWidth(50),
      bottom: AllpassScreenUtil.setHeight(15));

  static EdgeInsets smallTBPadding = EdgeInsets.only(
    top: AllpassScreenUtil.setHeight(25),
    bottom: AllpassScreenUtil.setHeight(25),
  );

  static EdgeInsets smallLPadding = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(50),
  );
}

/// 自定义图标
class CustomIcons {
  static const IconData chrome =
      const IconData(0xe684, fontFamily: "IconFont", matchTextDirection: true);
}

/// 主题
class AllpassTheme {
  static ThemeData blueTheme =  ThemeData(
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.blue,
    cursorColor: Colors.blue,
  );
  static ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    primarySwatch: Colors.red,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.red,
    cursorColor: Colors.red,
  );
  static ThemeData tealTheme = ThemeData(
    primaryColor: Colors.teal,
    primarySwatch: Colors.teal,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.teal,
    cursorColor: Colors.teal,
  );
  static ThemeData deepPurpleTheme = ThemeData(
    primaryColor: Colors.deepPurple,
    primarySwatch: Colors.deepPurple,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.deepPurple,
    cursorColor: Colors.deepPurple,
  );
  static ThemeData orangeTheme = ThemeData(
    primaryColor: Colors.orange,
    primarySwatch: Colors.orange,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.orange,
    cursorColor: Colors.orange,
  );
  static ThemeData pinkTheme = ThemeData(
    primaryColor: Colors.pink,
    primarySwatch: Colors.pink,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.pink,
    cursorColor: Colors.pink,
  );
  static ThemeData blueGreyTheme = ThemeData(
    primaryColor: Colors.blueGrey,
    primarySwatch: Colors.blueGrey,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.blueGrey,
    cursorColor: Colors.blueGrey,
  );
}

/// 其他样式
class AllpassUI {
  AllpassUI._();

  static const double smallBorderRadius = 8.0;
  static const double bigBorderRadius = 30.0;
}

Color getRandomColor(int seed) {
  Random random = Random(seed);
  int i = random.nextInt(AllpassColorUI.allColor.length - 1);
  return AllpassColorUI.allColor[i];
}
