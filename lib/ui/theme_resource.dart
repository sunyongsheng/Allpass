import 'package:flutter/material.dart';

import 'allpass_ui.dart';

/// 主题
class AllpassTheme {
  ThemeData blueTheme() {
    return defaultTheme(mainColor: Colors.blue);
  }

  ThemeData redTheme() {
    return defaultTheme(mainColor: Colors.red);
  }

  ThemeData tealTheme() {
    return defaultTheme(mainColor: Colors.teal);
  }

  ThemeData deepPurpleTheme() {
    return defaultTheme(mainColor: Colors.deepPurple);
  }

  ThemeData orangeTheme() {
    return defaultTheme(mainColor: Colors.orange);
  }

  ThemeData pinkTheme() {
    return defaultTheme(mainColor: Colors.pink);
  }

  ThemeData blueGreyTheme() {
    return defaultTheme(mainColor: Colors.blueGrey);
  }

  ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.blueAccent,
      primarySwatch: Colors.blue,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: Colors.white),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white70),
        elevation: 0,
        color: Colors.grey[900],
      ),
      iconTheme: IconThemeData(color: Colors.grey[200]),
      scaffoldBackgroundColor: Colors.grey[900],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),
      ),
      bottomSheetTheme:
          BottomSheetThemeData(modalBackgroundColor: Colors.grey[900]),
      dividerColor: Colors.grey,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.black,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[700],
        brightness: Brightness.dark,
        disabledColor: Colors.grey[700],
        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        labelStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(4),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        secondarySelectedColor: Colors.blue,
        selectedColor: Colors.blue,
        shape: StadiumBorder(),
      ),
      canvasColor: Colors.black,
    );
  }

  ThemeData defaultTheme({Color mainColor}) {
    return ThemeData(
      primaryColor: mainColor,
      primarySwatch: mainColor,
      floatingActionButtonTheme:
      FloatingActionButtonThemeData(foregroundColor: Colors.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          color: Colors.white,
          textTheme: TextTheme(title: TextStyle(color: Colors.black))),
      scaffoldBackgroundColor: Colors.white,
      indicatorColor: mainColor,
      cursorColor: mainColor,
      inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey[200]),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),
      ),
    );
  }
}
