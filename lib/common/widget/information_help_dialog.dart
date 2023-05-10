import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

class InformationHelpDialog extends StatefulWidget {
  final Widget? title;
  final List<Widget> content;
  final List<Widget>? actions;

  InformationHelpDialog({
    Key? key,
    this.title,
    required this.content,
    this.actions,
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
      title: widget.title ?? Text(context.l10n.help),
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