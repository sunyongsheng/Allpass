import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/custom_error_page.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/login/page/login_page.dart';
import 'package:allpass/login/page/auth_login_page.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/version_util.dart';
import 'package:allpass/core/model/api/allpass_response.dart';
import 'package:allpass/core/model/api/user_bean.dart';

bool needUpdateSecret = false;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (flutterErrorDetails) => CustomErrorPage(msg: flutterErrorDetails.toString());

  try {
    await AllpassApplication.initSp();
    await EncryptUtil.initEncrypt();
    Config.initConfig();
    AllpassApplication.initRouter();
    AllpassApplication.initLocator();
    AllpassApplication.initAndroidChannel();

    if (Platform.isAndroid) {
      //设置Android头部的导航栏透明
      var systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    // 此逻辑必须在_registerUser()之前执行，_registerUser()执行完后SP中allpassVersion已更新
    needUpdateSecret = !(AllpassApplication.sp.getBool(SPKeys.firstRun) ?? true)
        && VersionUtil.twoIsNewerVersion(AllpassApplication.sp.getString(SPKeys.allpassVersion), "1.5.0");

    _registerUser();

    final PasswordProvider passwords = PasswordProvider()
      ..init();
    final CardProvider cards = CardProvider()
      ..init();
    final ThemeProvider theme = ThemeProvider()
      ..init();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<PasswordProvider>.value(value: passwords),
        ChangeNotifierProvider<CardProvider>.value(value: cards),
        ChangeNotifierProvider<ThemeProvider>.value(value: theme)
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
    return ScreenUtilInit(
        designSize: Size(1080, 1920),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => MaterialApp(
          title: 'Allpass',
          theme: Provider.of<ThemeProvider>(context).lightTheme,
          darkTheme: Provider.of<ThemeProvider>(context).darkTheme,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!
            );
          },
          home: Config.enabledBiometrics ? AuthLoginPage() : LoginPage(),
          onGenerateRoute: AllpassApplication.router.generator,
          navigatorKey: AllpassApplication.navigationKey,
        )
    );
  }
}

void _registerUser() async {

  Future<Null> registerUserActual() async {
    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    String _identification = AllpassApplication.identification;
    String _systemInfo;
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await infoPlugin.androidInfo;
      _systemInfo = "${info.model} android${info.version.release}";
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await infoPlugin.iosInfo;
      _systemInfo = "${info.model} iOS${info.systemVersion}";
    } else {
      return;
    }

    try {
      UserBean user = UserBean(identification: _identification, systemInfo: _systemInfo, version: AllpassApplication.version);
      AllpassResponse response = await AllpassApplication.getIt<AllpassService>().registerUser(user);
      if (response.success) {
        AllpassApplication.sp.setBool(SPKeys.needRegister, false);
      } else {
        AllpassApplication.sp.setBool(SPKeys.needRegister, true);
      }
    } catch (e) {
      debugPrint("用户注册失败：${e.toString()}");
    }
  }

  DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo info = await infoPlugin.androidInfo;
    AllpassApplication.identification = info.androidId;
    AllpassApplication.systemSdkInt = info.version.sdkInt;
    AllpassApplication.isAndroid = true;
  } else if (Platform.isIOS) {
    IosDeviceInfo info = await infoPlugin.iosInfo;
    AllpassApplication.identification= info.identifierForVendor;
    AllpassApplication.systemSdkInt = -1;
    AllpassApplication.isAndroid = false;
  }

  if (AllpassApplication.sp.getBool(SPKeys.needRegister)??true) {
    await registerUserActual();
  } else {
    if (!((AllpassApplication.sp.getString(SPKeys.allpassVersion)??"1.0.0") == AllpassApplication.version)) {
      await registerUserActual();
      AllpassApplication.sp.setString(SPKeys.allpassVersion, AllpassApplication.version);
    }
  }
}
