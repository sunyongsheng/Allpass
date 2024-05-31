import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

import 'package:allpass/common/ui/allpass_ui.dart';

/// 详细文字展示页，用于展示比较长而不能在上一页面进行全部显示的文字
/// 可以设置[canChange]属性来决定其中文字是否可以修改，返回修改后的文字
class DetailTextPage extends StatefulWidget {

  final String title;
  final String text;
  final void Function(String)? onChanged;

  DetailTextPage(this.title, this.text, this.onChanged);

  @override
  State createState() {
    return _DetailTextState();
  }
}

class _DetailTextState extends State<DetailTextPage> {

  final TextEditingController _controller = TextEditingController();

  late VoidCallback listener;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;

    listener = () {
      widget.onChanged?.call(_controller.text);
    };
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(listener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.onChanged != null) {
      child = TextField(
        autofocus: true,
        controller: _controller,
        maxLines: 1000,
        style: AllpassTextUI.firstTitleStyle,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          suffix: InkWell(
            child: Icon(
              Icons.cancel,
              size: 20,
            ),
            onTap: () {
              // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _controller.clear());
            },
          ),
          hintText: context.l10n.addNotes,
        ),
      );
    } else {
      child = Text(
        widget.text,
        style: AllpassTextUI.firstTitleStyle,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: child,
              padding: AllpassEdgeInsets.listInset,
            )
          ],
        ),
      ),
    );
  }
}
