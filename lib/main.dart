import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:allpass/pages/login/login_page.dart';
import 'package:allpass/pages/login/auth_login_page.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/application.dart';
import 'package:allpass/route/routes.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  Application.setupLocator();
  await Application.initSp();
  Application.initChannelAndHandle();
  await Config.configInit();

  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  // 自定义报错页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          child: Text("App出现错误，快去反馈给作者!"),
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
        Padding(
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
        Padding(
          child: Text("以下是出错信息，请截图发到邮箱sys6511@126.com"),
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
        Padding(
          child: Text(flutterErrorDetails.toString()),
          padding: AllpassEdgeInsets.smallTBPadding,
        ),
      ],
    );
  };

  final PasswordList passwords = PasswordList()..init();
  final CardList cards = CardList()..init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PasswordList>.value(
        value: passwords,
      ),
      ChangeNotifierProvider<CardList>.value(
        value: cards,
      )
    ],
    child: Allpass(),
  ));
}

class Allpass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allpass',
      theme: ThemeData.light(),
      home: Config.enabledBiometrics ? AuthLoginPage() : LoginPage(),
      onGenerateRoute: Application.router.generator,
    );
  }
}
