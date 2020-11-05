import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/navigation_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';


/// 生物识别登录页
class AuthLoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AuthLoginPage();
  }
}

class _AuthLoginPage extends State<StatefulWidget> {

  final AuthService _localAuthService = Application.getIt<AuthService>();
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
            color: Colors.transparent,
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
    // 两次时间
    DateTime now = DateTime.now();
    DateTime latestUsePassword = DateTime.parse(Application.sp.get(SPKeys.latestUsePassword)??now.toIso8601String());
    if (now.difference(latestUsePassword).inDays >= Config.timingInMainPassword) {
      await _localAuthService.stopAuthenticate();
      showDialog<bool>(
        context: context,
        builder: (context) => InputMainPasswordDialog(
          helperText: "Allpass会定期要求您输入密码以防止您忘记主密码",
        ),
      ).then((value) {
        if (value) {
          Fluttertoast.showToast(msg: "验证成功");
          Application.updateLatestUsePasswordTime();
          NavigationUtil.goHomePage(context);
        } else {
          Fluttertoast.showToast(msg: "您似乎忘记了主密码");
          NavigationUtil.goLoginPage(context);
        }
      });
    } else {
      var authSucceed = await _localAuthService.authenticate();
      if (authSucceed) {
        Fluttertoast.showToast(msg: "验证成功");
        NavigationUtil.goHomePage(context);
      } else {
        Fluttertoast.showToast(msg: "认证失败，请重试");
      }
    }
  }
}