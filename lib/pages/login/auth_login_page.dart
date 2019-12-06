import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/navigation_util.dart';
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            splashColor: AllpassColorUI.mainBackgroundColor,
            color: AllpassColorUI.mainBackgroundColor,
            autofocus: true,
            onPressed: () async {
              var authSucceed = await _localAuthService.authenticate();
              if (authSucceed) {
                Fluttertoast.showToast(msg: "验证成功");
                NavigationUtil.goHomePage(context);
              } else {
                Fluttertoast.showToast(msg: "认证失败，请重试");
              }
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.fingerprint, size: 50,),
                Padding(padding: EdgeInsets.only(top: 10),),
                Text("使用指纹登录")
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 80),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("使用密码登录"),
                onPressed: () {
                  NavigationUtil.goLoginPage(context);
                },
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10),)
        ],
      ),
    );
  }

}