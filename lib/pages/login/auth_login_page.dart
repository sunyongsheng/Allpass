import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_utils.dart';
import 'package:allpass/services/local_authentication_service.dart';


/// 生物识别登录页
class AuthLoginPage extends StatelessWidget {

  final LocalAuthenticationService _localAuthService = Application.getIt<LocalAuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("使用指纹登录"),
                autofocus: true,
                onPressed: () async {
                  var authSucceed = await _localAuthService.authenticate();
                  if (authSucceed) {
                    Fluttertoast.showToast(msg: "验证成功");
                    NavigationUtils.goHomePage(context);
                  } else {
                    Fluttertoast.showToast(msg: "认证失败，请重试");
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("使用密码登录"),
                onPressed: () {
                  NavigationUtils.goLoginPage(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

}