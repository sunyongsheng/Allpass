import 'package:flutter/material.dart';
import 'package:allpass/application.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/util/screen_util.dart';

class AuthDialog extends StatefulWidget {

  @override
  State createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {

  final AuthService _localAuthService = AllpassApplication.getIt<AuthService>();

  bool error = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (await _localAuthService.authenticate() == AuthResult.Success) {
        setState(() {
          error = false;
        });
        Navigator.pop<bool>(context, true);
      } else {
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _localAuthService.stopAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      children: [
        Column(
          children: [
            Icon(Icons.fingerprint,
              size: AllpassScreenUtil.setWidth(200),
              color: error ? Colors.redAccent : null,
            ),
            Padding(padding: EdgeInsets.only(top: AllpassScreenUtil.setHeight(20))),
            Text(error ? "验证失败，请重试" : "请验证指纹",
              style: error ? TextStyle(color: Colors.redAccent) : null,
            )
          ],
        )
      ],
    );
  }
}