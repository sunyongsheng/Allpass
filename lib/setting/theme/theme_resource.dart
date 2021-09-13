import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/ui/allpass_ui.dart';

/// 主题
class AllpassTheme {
  ThemeData blueTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.blue);
    } else {
      return defaultTheme(mainColor: Colors.blue);
    }
  }

  ThemeData redTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.red);
    } else {
      return defaultTheme(mainColor: Colors.red);
    }
  }

  ThemeData tealTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.teal);
    } else {
      return defaultTheme(mainColor: Colors.teal);
    }
  }

  ThemeData deepPurpleTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.deepPurple);
    } else {
      return defaultTheme(mainColor: Colors.deepPurple);
    }
  }

  ThemeData orangeTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.orange);
    } else {
      return defaultTheme(mainColor: Colors.orange);
    }
  }

  ThemeData pinkTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.pink);
    } else {
      return defaultTheme(mainColor: Colors.pink);
    }
  }

  ThemeData blueGreyTheme(bool dark) {
    if (dark) {
      return darkTheme(mainColor: Colors.blueGrey);
    } else {
      return defaultTheme(mainColor: Colors.blueGrey);
    }
  }

  ThemeData darkTheme({Color mainColor}) {
    return ThemeData(
      primaryColor: mainColor,
      primarySwatch: mainColor,
      accentColor: mainColor,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white70),
        elevation: 0,
        color: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white)
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: mainColor
      ),
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
      indicatorColor: mainColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: mainColor
      ),
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
        button: TextStyle(color: mainColor),
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
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              alignment: Alignment.center,
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)
              ))
          )
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[700],
        brightness: Brightness.dark,
        disabledColor: Colors.grey[700],
        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        labelStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(4),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        secondarySelectedColor: mainColor,
        selectedColor: mainColor,
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
        foregroundColor: Colors.white
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black)
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        selectedItemColor: mainColor,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey
      ),
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          alignment: Alignment.center,
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)
          ))
        )
      ),
      indicatorColor: mainColor,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: mainColor
        ),
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
