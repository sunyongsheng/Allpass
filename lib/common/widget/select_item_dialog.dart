import 'package:flutter/material.dart';

class SelectItemDialog extends StatelessWidget {

  final Key? key;
  final List<String> _list;
  final String? initialSelected;

  SelectItemDialog(this._list, {this.key, this.initialSelected}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请选择"),
      content: SingleChildScrollView(
        child: Column(
          children: _getList(context)
        ),
      )
    );
  }

  List<Widget> _getList(BuildContext context) {
    List<Widget> list = [];
    for (String f in _list) {
      list.add(ListTile(
        title: Text(f),
        trailing: f == initialSelected
            ? Icon(Icons.check, color: Colors.grey,)
            : null,
        onTap: () => Navigator.pop<String>(context, f),
      ));
    }
    return list;
  }

}