import 'package:flutter/material.dart';
import 'package:allpass/util/theme_util.dart';

class LabelChip extends StatelessWidget {
  final Key key;
  final String text;
  final bool selected;
  final void Function(bool) onSelected;
  const LabelChip({this.key, this.text, this.selected, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (ThemeUtil.isInDarkTheme(context)) {
      textColor = Colors.white;
    } else {
      if (selected) {
        textColor = Colors.white;
      } else {
        textColor = Colors.black;
      }
    }
    return ChoiceChip(
      label: Text(text),
      labelStyle: TextStyle(fontSize: 14, color: textColor),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).primaryColor,
    );
  }

}