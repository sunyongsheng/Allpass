import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';


class InitialErrorApp extends StatelessWidget {

  final String? errorMsg;

  const InitialErrorApp({Key? key, this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.l10n.allpass,
      home: CustomErrorPage(msg: errorMsg),
    );
  }
}

class CustomErrorPage extends StatelessWidget {

  final String? msg;

  const CustomErrorPage({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appError,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text(l10n.appErrorHint1),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Padding(
              child: Text(l10n.appErrorHint2),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Padding(
              child: Text(msg ?? "null", style: TextStyle(color: Colors.red),),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
      ),
    );
  }
}