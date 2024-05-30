import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 主题
class AllpassTheme {

  var _useMaterial3 = false;

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

  ThemeData darkTheme({required MaterialColor mainColor}) {
    return ThemeData(
      useMaterial3: _useMaterial3,
      primaryColor: mainColor,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: mainColor)
          .copyWith(secondary: mainColor),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white70),
        elevation: 0,
        color: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: AllpassUI.smallRadius,
            topRight: AllpassUI.smallRadius,
          ),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.grey[400]),
      cardTheme: CardTheme(
        color: Colors.grey[900],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      indicatorColor: mainColor,
      textSelectionTheme: TextSelectionThemeData(cursorColor: mainColor),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Color(0xFFA1A1A1)),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: mainColor),
        titleLarge: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(25, 25, 25, 1),
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      dividerColor: Colors.grey,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[900],
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: AllpassUI.smallBorderRadius,
          borderSide: BorderSide.none,
        ),
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return TextStyle(color: mainColor);
          } else {
            return TextStyle(color: Colors.grey);
          }
        }),
        helperStyle: TextStyle(color: Colors.grey),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          alignment: Alignment.center,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: AllpassUI.smallBorderRadius,
            ),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[700]!,
        brightness: Brightness.dark,
        disabledColor: Colors.grey[700]!,
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
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      listTileTheme: ListTileThemeData(minLeadingWidth: 32),
    );
  }

  ThemeData defaultTheme({required MaterialColor mainColor}) {
    return ThemeData(
      useMaterial3: _useMaterial3,
      primaryColor: mainColor,
      primarySwatch: mainColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        selectedItemColor: mainColor,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.black),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          alignment: Alignment.center,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: AllpassUI.smallBorderRadius,
            ),
          ),
        ),
      ),
      indicatorColor: mainColor,
      textSelectionTheme: TextSelectionThemeData(cursorColor: mainColor),
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 14,),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color.fromRGBO(245, 246, 250, 1),
        border: OutlineInputBorder(
          borderRadius: AllpassUI.smallBorderRadius,
          borderSide: BorderSide.none,
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: AllpassUI.smallRadius,
            topRight: AllpassUI.smallRadius,
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AllpassUI.smallBorderRadius,
        ),
      ),
      listTileTheme: ListTileThemeData(minLeadingWidth: 32),
    );
  }
}
