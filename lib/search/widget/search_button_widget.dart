import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class SearchButtonWidget extends StatelessWidget {

  final Key key;
  final String searchType;
  final VoidCallback press;

  SearchButtonWidget(this.press, this.searchType, {this.key});

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
        splashColor: Colors.transparent,
      ),
    );
  }

}