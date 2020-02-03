import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class CheckUpdateDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CheckUpdateDialog();
  }
}

class _CheckUpdateDialog extends State<StatefulWidget> {

  var _checkRes;
  bool _update = false;
  Widget _content;
  String _updateContent;

  @override
  void initState() {
    super.initState();
    _checkRes = checkUpdate();
  }

  Future<Null> checkUpdate() async {
    await Future.delayed(Duration(seconds: 1)).then((_) {
      _updateContent = "sadsadsadas";
      _update = false;
    });
    _content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _update
            ? Text("有新版本可以下载！")
            : Text("您的版本是最新版！"),
        _update
            ? Padding(
          padding: AllpassEdgeInsets.smallTBPadding,
          child: Text("更新内容：", style: TextStyle(fontWeight: FontWeight.bold),),
        )
            : Padding(
          padding: AllpassEdgeInsets.smallTBPadding,
          child: Text("最近更新：", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        Text(_updateContent)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkRes,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(AllpassUI.smallBorderRadius))
              ),
              title: Text("检查更新"),
              content: SingleChildScrollView(
                child: _content,
              ),
              actions: <Widget>[
                _update
                ? FlatButton(
                  child: Text("下载更新"),
                  onPressed: () {

                  },
                )
                : FlatButton(
                  child: Text("确认"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}