import 'package:flutter/material.dart';

import 'package:allpass/common/ui/allpass_ui.dart';

/// 详细文字展示页，用于展示比较长而不能在上一页面进行全部显示的文字
/// 可以设置[canChange]属性来决定其中文字是否可以修改，返回修改后的文字
class DetailTextPage extends StatelessWidget {
  final String title;
  final String text;
  final bool canChange;
  final TextEditingController _controller = TextEditingController();

  DetailTextPage(this.title, this.text, this.canChange) {
    _controller.text = this.text;
  }

  @override
  Widget build(BuildContext context) {
    if (canChange) {
      return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: AllpassTextUI.titleBarStyle,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      maxLines: 1000,
                      style: AllpassTextUI.firstTitleStyle,
                      decoration: InputDecoration(
                        suffix: InkWell(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                          ),
                          onTap: () {
                            // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                            WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
                          },
                        ),
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
                title,
                style: AllpassTextUI.titleBarStyle,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: Text(text,
                      style: AllpassTextUI.firstTitleStyle,
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