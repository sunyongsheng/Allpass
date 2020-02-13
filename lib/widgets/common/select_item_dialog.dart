import 'package:flutter/material.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/utils/allpass_ui.dart';

class SelectItemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请选择"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: _getList(context)
        ),
      )
    );
  }

  List<Widget> _getList(BuildContext context) {
    List<Widget> list = List();
    for (String f in RuntimeData.folderList) {
      list.add(ListTile(
        title: Text(f),
        onTap: () => Navigator.pop<String>(context, f),
      ));
    }
    return list;
  }

}