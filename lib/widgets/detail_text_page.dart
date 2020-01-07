import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class DetailTextPage extends StatelessWidget {
  final String text;
  final bool canChange;
  final TextEditingController _controller = TextEditingController();

  DetailTextPage(this.text, this.canChange) {
    _controller.text = this.text;
  }

  @override
  Widget build(BuildContext context) {
    if (canChange) {
      return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "备注",
                style: AllpassTextUI.titleBarStyle,
              ),
              centerTitle: true,
              backgroundColor: AllpassColorUI.mainBackgroundColor,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              brightness: Brightness.light,
            ),
            backgroundColor: AllpassColorUI.mainBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      maxLines: 1000,
                      style: AllpassTextUI.firstTitleStyleBlack,
                      decoration: InputDecoration(
                          hintText: "添加备注",
                      ),
                    ),
                    padding: AllpassEdgeInsets.listInset,
                  )
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.pop<String>(context, _controller.text);
            return Future.value(false);
          }
      );
    } else {
      return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "备注",
                style: AllpassTextUI.titleBarStyle,
              ),
              centerTitle: true,
              backgroundColor: AllpassColorUI.mainBackgroundColor,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              brightness: Brightness.light,
            ),
            backgroundColor: AllpassColorUI.mainBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: Text(text,
                      style: AllpassTextUI.firstTitleStyleBlack,
                    ),
                    padding: AllpassEdgeInsets.listInset,
                  )
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.pop<String>(context, text);
            return Future.value(false);
          }
      );
    }

  }

}