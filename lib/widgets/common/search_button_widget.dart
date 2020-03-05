import 'package:flutter/material.dart';
import 'package:allpass/utils/allpass_ui.dart';

class SearchButtonWidget extends StatelessWidget {

  final String searchType;
  final void Function() press;

  SearchButtonWidget(this.press, this.searchType);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AllpassEdgeInsets.forSearchButtonInset,
      child: FlatButton(
        onPressed: press,
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            Text("搜索$searchType"),
          ],
        ),
        color: Theme.of(context).inputDecorationTheme.fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
        splashColor: Colors.transparent,
      ),
    );
  }

}