import 'dart:async';

import 'package:flutter/material.dart';

class ProgressDialog<T> extends StatefulWidget {

  final Future<bool> Function(void Function(double) onUpdateProgress) _execution;

  ProgressDialog(this._execution);

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
    widget._execution((progress) {
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
    if (_running) {
      return Center(
        child: CircularProgressIndicator(
          value: _progress,
        ),
      );
    } else {
      return Center(
        child: Icon(
          Icons.check_circle,
          size: 50,
          color: Colors.white,
        ),
      );
    }
  }
}