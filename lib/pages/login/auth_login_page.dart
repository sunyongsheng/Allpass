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
      body:Center(
          child: ListTile(
            title: Text("请使用指纹登陆"),
            onTap: () async {
              var authSucceed = await _localAuthService.authenticate();
              if (authSucceed) {
                NavigationUtils.goHomePage(context);
              } else {
                Fluttertoast.showToast(msg: "认证失败，请重试");
              }
            },
          )
      ),
    );
  }

}