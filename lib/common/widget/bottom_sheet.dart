import 'package:flutter/material.dart';

class BaseBottomSheet extends StatelessWidget {

  final List<Widget> Function(BuildContext context) builder;

  const BaseBottomSheet({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        height: 8,
      ),
    ]
      ..addAll(builder(context));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
