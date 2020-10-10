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
      accentColor: Colors.grey,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white70),
        elevation: 0,
        color: Colors.black,
      ),
      bottomAppBarColor: Colors.black,
      floatingActionButtonTheme:
        FloatingActionButtonThemeData(foregroundColor: Colors.white),
      scaffoldBackgroundColor: Colors.black,
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AllpassUI.smallBorderRadius),
                topRight: Radius.circular(AllpassUI.smallBorderRadius)
            )
        ),
      ),
      iconTheme: IconThemeData(color: Colors.grey[400]),
      cardTheme: CardTheme(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius))
      ),
      indicatorColor: Colors.blueAccent,
      cursorColor: Colors.blueAccent,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white),
        headline2: TextStyle(color: Colors.white),
        headline3: TextStyle(color: Colors.white),
        headline4: TextStyle(color: Colors.white),
        headline5: TextStyle(color: Colors.white),
        caption: TextStyle(color: Colors.white),
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.white),
        subtitle2: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(25, 25, 25, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),

      ),
      dividerColor: Colors.grey,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.grey[900],
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius)),
            borderSide: BorderSide.none
        )
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
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
      canvasColor: Colors.black,
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),
      )
    );
  }

  ThemeData defaultTheme({Color mainColor}) {
    return ThemeData(
      primaryColor: mainColor,
      primarySwatch: mainColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          color: Colors.white,
          textTheme: TextTheme(headline6: TextStyle(color: Colors.black))),
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
      ),
      indicatorColor: mainColor,
      cursorColor: mainColor,
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
        elevation: 1.5
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color.fromRGBO(245, 246, 250, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius)),
          borderSide: BorderSide.none
        )
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AllpassUI.smallBorderRadius),
                topRight: Radius.circular(AllpassUI.smallBorderRadius)
            )
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AllpassUI.smallBorderRadius),
          ),
        ),
      )
    );
  }
}
