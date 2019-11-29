import 'package:flutter/material.dart';

class SearchButtonWidget extends StatelessWidget {

  final void Function() press;

  SearchButtonWidget(this.press);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: FlatButton(
        onPressed: () => press(),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            Text("搜索"),
          ],
        ),
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
        splashColor:
        Colors.grey[200], // 设置成和FlatButton.color一样的值，点击时不会点击效果
      ),
    );
  }

}