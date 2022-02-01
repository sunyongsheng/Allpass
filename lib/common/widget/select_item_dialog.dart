import 'package:flutter/material.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T data);

abstract class SelectItemDialog<T> extends StatelessWidget {
  final Key? key;
  final List<T> list;
  final bool Function(T)? selector;

  final bool Function(T) defaultSelector = (data) => false;

  SelectItemDialog({required this.list, this.key, this.selector}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请选择"),
      content: SingleChildScrollView(
        child: Column(
            children: _getList(context)
        ),
      ),
      actions: buildActions(context),
    );
  }

  List<Widget> _getList(BuildContext context) {
    List<Widget> widgetList = [];
    for (T data in list) {
      widgetList.add(buildItem(context, data));
    }
    return widgetList;
  }

  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  Widget buildItem(BuildContext context, T data);
}

class DefaultSelectItemDialog<T> extends SelectItemDialog<T> {

  final WidgetBuilder<T>? itemBuilder;

  final WidgetBuilder<T> defaultItemBuilder = (_, data) => Text(data.toString());

  DefaultSelectItemDialog({required List<T> list, this.itemBuilder, Key? key, bool Function(T)? selector}) : super(
    list: list,
    key: key,
    selector: selector
  );


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

  @override
  Widget buildItem(BuildContext context, T data) {
    return ListTile(
      title: itemBuilder?.call(context, data) ?? defaultItemBuilder(context, data),
      trailing: selector?.call(data) ?? defaultSelector(data)
          ? Icon(Icons.check, color: Colors.grey,)
          : null,
      onTap: () => Navigator.pop<T>(context, data),
    );
  }

}