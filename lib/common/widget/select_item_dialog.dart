import 'package:flutter/material.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T data);

class SelectItemDialog<T> extends StatelessWidget {

  final Key? key;
  final List<T> list;
  final bool Function(T)? selector;
  final WidgetBuilder<T> itemBuilder;

  final bool Function(T) defaultSelector = (data) => false;

  SelectItemDialog({required this.list, required this.itemBuilder, this.key, this.selector}): super(key: key);

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
    List<Widget> widgetList = [];
    for (T data in list) {
      widgetList.add(ListTile(
        title: itemBuilder(context, data),
        trailing: (selector ?? defaultSelector).call(data)
            ? Icon(Icons.check, color: Colors.grey,)
            : null,
        onTap: () => Navigator.pop<T>(context, data),
      ));
    }
    return widgetList;
  }

}