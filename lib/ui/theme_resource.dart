import 'package:flutter/material.dart';

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
          color: Colors.grey[900],
        ),
        iconTheme: IconThemeData(
            color: Colors.grey[200]
        ),
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
        ),
        bottomSheetTheme: BottomSheetThemeData(
            modalBackgroundColor: Colors.grey[900]
        ),
        dividerColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          fillColor: Colors.black,
          hintStyle: TextStyle(color: Colors.grey),
        ),
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.accent
        ),
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
        canvasColor: Colors.black
    );
  }
}