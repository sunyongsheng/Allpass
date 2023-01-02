import 'package:flutter/material.dart';

class InformationHelpDialog extends StatefulWidget {

  final Key? key;
  final Widget title;
  final List<Widget> content;
  final List<Widget>? actions;

  InformationHelpDialog({this.key,
    this.title = const Text("帮助"),
    required this.content,
    this.actions
  }) : super(key: key);

  @override
  State createState() {
    return _InformationHelpDialog();
  }
}

class _InformationHelpDialog extends State<InformationHelpDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: widget.key,
      title: widget.title,
      scrollable: true,
      content: SingleChildScrollView(
          child: ListBody(
            children: widget.content
          )
      ),
      actions: widget.actions,
    );
  }
}