import 'dart:math';

import 'package:flutter/material.dart';

import 'package:allpass/utils/screen_util.dart';

/// 保存所有Allpass用到的文本样式
class AllpassTextUI {
  AllpassTextUI._();

  static final TextStyle titleBarStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5);

  static final TextStyle firstTitleStyle =
      TextStyle(fontSize: 16);
  static final TextStyle secondTitleStyle =
      TextStyle(fontSize: 14);

  static final TextStyle smallTextStyle =
      TextStyle(fontSize: 12);
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
  static ThemeData blueTheme() {
    return ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.blue,
        cursorColor: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData redTheme() {
    return ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.red,
        cursorColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData tealTheme() {
    return ThemeData(
        primaryColor: Colors.teal,
        primarySwatch: Colors.teal,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.teal,
        cursorColor: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData deepPurpleTheme() {
    return ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.deepPurple,
        cursorColor: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData orangeTheme() {
    return ThemeData(
        primaryColor: Colors.orange,
        primarySwatch: Colors.orange,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.orange,
        cursorColor: Colors.orange,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData pinkTheme() {
    return ThemeData(
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.pink,
        cursorColor: Colors.pink,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData blueGreyTheme() {
    return ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            color: Colors.white,
            textTheme: TextTheme(title: TextStyle(color: Colors.black))
        ),
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: Colors.blueGrey,
        cursorColor: Colors.blueGrey,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200]
        )
    );
  }
  static ThemeData darkTheme() {
    return ThemeData(
        primaryColor: Colors.blueAccent,
        primarySwatch: Colors.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white70),
          elevation: 0,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(
            color: Colors.grey[200]
        ),
        scaffoldBackgroundColor: Colors.black54,
        cardColor: Colors.black,
        indicatorColor: Colors.blueAccent,
        cursorColor: Colors.blueAccent,
        accentColor: Colors.grey,
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          display1: TextStyle(color: Colors.white),
          display2: TextStyle(color: Colors.white),
          display3: TextStyle(color: Colors.white),
          display4: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          body1: TextStyle(color: Colors.white),
          body2: TextStyle(color: Colors.white),
          subtitle: TextStyle(color: Colors.white),
          subhead: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          headline: TextStyle(color: Colors.white),
        ),
        bottomAppBarColor: Colors.grey[900],
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
        ),
        bottomSheetTheme: BottomSheetThemeData(
            modalBackgroundColor: Colors.grey[900]
        ),
        dividerColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          fillColor: Colors.grey[900],
          hintStyle: TextStyle(color: Colors.grey),
        ),
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.accent
        )
    );
  }
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
