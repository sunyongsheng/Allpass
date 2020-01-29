import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_util.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/services/authentication_service.dart';


/// 生物识别登录页
class AuthLoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AuthLoginPage();
  }
}

class _AuthLoginPage extends State<StatefulWidget> {

  final AuthenticationService _localAuthService = Application.getIt<AuthenticationService>();
  WidgetsBinding widgetsBinding = WidgetsBinding.instance;

  @override
  void initState() {
    widgetsBinding.addPostFrameCallback((callback) => askAuth(context));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            child: Text(
              "登录 Allpass",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            padding: AllpassEdgeInsets.smallTBPadding,
          ),
          Padding(
            padding: AllpassEdgeInsets.smallTBPadding,
          ),
          FlatButton(
            splashColor: AllpassColorUI.mainBackgroundColor,
            color: AllpassColorUI.mainBackgroundColor,
            autofocus: true,
            onPressed: () => askAuth(context),
            child: Column(
              children: <Widget>[
                Icon(Icons.fingerprint, size: AllpassScreenUtil.setWidth(150),),
                Padding(padding: EdgeInsets.only(
                    top: AllpassScreenUtil.setHeight(40)),),
                Text("点击此处使用指纹登录")
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(200)),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("使用密码登录"),
                onPressed: () async {
                  await _localAuthService.stopAuthenticate();
                  NavigationUtil.goLoginPage(context);
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AllpassScreenUtil.setHeight(80)),)
        ],
      ),
    );
  }

  Future<Null> askAuth(BuildContext context) async {
    var authSucceed = await _localAuthService.authenticate();
    if (authSucceed) {
      Fluttertoast.showToast(msg: "验证成功");
      NavigationUtil.goHomePage(context);
    } else {
      Fluttertoast.showToast(msg: "认证失败，请重试");
    }
  }
}