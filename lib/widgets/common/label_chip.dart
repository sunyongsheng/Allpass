import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/provider/theme_provider.dart';

class LabelChip extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function(bool) onSelected;
  const LabelChip({this.text, this.selected, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(text),
      labelStyle: TextStyle(fontSize: 14, color: Colors.white),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Provider.of<ThemeProvider>(context).currTheme.primaryColor,
    );
  }

}