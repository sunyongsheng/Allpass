import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class LoadingTextButton extends StatelessWidget {

  final Key? key;
  final Color color;
  final VoidCallback onPressed;
  final String title;
  final String? loadingTitle;
  final bool? loading;

  LoadingTextButton({
    required this.color,
    required this.title,
    this.loadingTitle,
    required this.onPressed,
    this.loading,
    this.key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];
    if (loading ?? false) {
      childWidgets.add(Text(loadingTitle ?? title, style: TextStyle(color: Colors.white)));
      childWidgets.add(Padding(padding: EdgeInsets.symmetric(horizontal: 3)));
      childWidgets.add(SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 2,)
      ));
    } else {
      childWidgets.add(Text(title, style: TextStyle(color: Colors.white)));
    }

    return MaterialButton(
      minWidth: double.infinity,
      color: color,
      onPressed: onPressed,
      elevation: 0,
      height: 40,
      focusElevation: 0,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AllpassUI.smallBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: childWidgets,
      ),
    );
  }
}
