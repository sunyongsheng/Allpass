import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/provider/theme_provider.dart';

class NoneBorderCircularTextField extends StatelessWidget {
  final TextEditingController editingController;
  final String hintText;
  final Widget prefixIcon;
  final bool obscureText;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final TextAlign textAlign;
  final Widget trailing;

  NoneBorderCircularTextField({
    @required this.editingController,
    this.hintText,
    this.prefixIcon,
    this.textAlign: TextAlign.center,
    this.obscureText: false,
    this.onEditingComplete,
    this.trailing,
    this.onChanged});

  @override
  Widget build(BuildContext context) {
    Color _filledColor;
    if (Config.theme != "dark") {
      _filledColor = Provider.of<ThemeProvider>(context).backgroundColor2;
    } else {
      _filledColor = Colors.black;
    }
    return Padding(
      padding: AllpassEdgeInsets.smallTBPadding,
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
            ),
            filled: true,
            fillColor: _filledColor,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            suffix: trailing
        ),
        textAlign: textAlign,
        controller: editingController,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
      ),
    );
  }
}