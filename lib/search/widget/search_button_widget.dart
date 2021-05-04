import 'package:allpass/util/theme_util.dart';
import 'package:flutter/material.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class SearchButtonWidget extends StatelessWidget {

  final Key key;
  final String searchType;
  final VoidCallback press;

  SearchButtonWidget(this.press, this.searchType, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = ThemeUtil.isInDarkTheme(context) ? Colors.grey : Colors.grey[900];
    return Container(
      padding: AllpassEdgeInsets.forSearchButtonInset,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all((Theme.of(context).inputDecorationTheme.fillColor)),
        ),
        onPressed: press,
        child: Row(
          children: <Widget>[
            Icon(Icons.search, color: textColor,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
            Text("搜索$searchType", style: TextStyle(color: textColor),),
          ],
        )
      ),
    );
  }

}