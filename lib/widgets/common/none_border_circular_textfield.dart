import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class NoneBorderCircularTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String _hintText;
  final Widget _prefixIcon;
  final bool _obscureText;
  final VoidCallback _onEditingComplete;

  NoneBorderCircularTextField(this._controller, this._hintText, this._prefixIcon, this._obscureText, this._onEditingComplete);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AllpassEdgeInsets.smallTBPadding,
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: _prefixIcon,
            hintText: _hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AllpassUI.bigBorderRadius),
            ),
            fillColor: Colors.grey[200],
            filled: true,
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0)
        ),
        textAlign: TextAlign.center,
        controller: _controller,
        obscureText: _obscureText,
        onEditingComplete: _onEditingComplete,
      ),
    );
  }
}