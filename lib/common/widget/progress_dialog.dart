import 'dart:async';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:flutter/material.dart';

class ProgressDialog<T> extends StatefulWidget {
  final String? completeHint;
  final String runningHint;
  final Future<bool> Function(void Function(double) onUpdateProgress) execution;

  ProgressDialog({
    this.completeHint,
    required this.runningHint,
    required this.execution,
  });

  @override
  State createState() {
    return _ProgressDialogState();
  }
}

class _ProgressDialogState<T> extends State<ProgressDialog> {

  double _progress = 0;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    widget.execution((progress) {
      setState(() {
        _progress = progress;
      });
    }).then((finish) {
      setState(() {
        _running = !finish;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[];
    if (_running) {
      content = [
        CircularProgressIndicator(
          value: _progress,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        Text(
          widget.runningHint,
          style: AllpassTextUI.settingTrailing,
        )
      ];
    } else {
      content = [
        Icon(
          Icons.check_circle,
          size: 50,
          color: Colors.white,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        Text(
          widget.completeHint ?? widget.runningHint,
          style: AllpassTextUI.settingTrailing,
        )
      ];
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 120),
      child: Container(
        height: 120,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: content,
          ),
        ),
      ),
    );
  }
}