import 'dart:io' show Platform;

import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/initializer/di_initializer.dart';
import 'package:allpass/login/page/login_arguments.dart';
import 'package:allpass/login/page/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/custom_error_page.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/login/page/login_page.dart';
import 'package:allpass/login/page/auth_login_page.dart';
import 'package:allpass/encrypt/encrypt_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (flutterErrorDetails) => CustomErrorPage(msg: flutterErrorDetails.toString());

  try {
    await AllpassApplication.initSp();
    await EncryptUtil.initEncrypt();
    await AllpassApplication.initRuntime();
    Config.initConfig();
    AllpassApplication.initRouter();
    GetItInitializer.initialize();
    AllpassApplication.initAndroidChannel();

    if (Platform.isAndroid) {
      //设置Android头部的导航栏透明
      var systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    final PasswordProvider passwords = PasswordProvider()..init();
    final CardProvider cards = CardProvider()..init();
    final CategoryProvider category = CategoryProvider()..init();
    final ThemeProvider theme = ThemeProvider()..init();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<PasswordProvider>.value(value: passwords),
        ChangeNotifierProvider<CardProvider>.value(value: cards),
        ChangeNotifierProvider<ThemeProvider>.value(value: theme),
        ChangeNotifierProvider<CategoryProvider>.value(value: category),
      ],
      child: Allpass(),
    ));
  } on Error catch (e) {
    runApp(InitialErrorApp(
        errorMsg: " ${e.runtimeType.toString()} \n ${e.toString()}\n ${e.stackTrace.toString()}"
    ));
  }
}

class Allpass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget initialPage;
    if (Config.password.isEmpty) {
      initialPage = RegisterPage();
    } else {
      if (Config.allowUseAuthLogin()) {
        initialPage = AuthLoginPage(arguments: LoginArguments(),);
      } else {
        initialPage = LoginPage(arguments: LoginArguments(),);
      }
    }

    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, homePage) => Selector<ThemeProvider, AppTheme>(
        selector: (_, provider) => provider.appTheme,
        builder: (_, theme, home) => MaterialApp(
          title: 'Allpass',
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: AllpassApplication.router.generator,
          navigatorKey: AllpassApplication.navigationKey,
          home: home,
        ),
        child: homePage,
      ),
      child: initialPage,
    );
  }
}
