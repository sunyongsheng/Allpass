import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:device_apps/device_apps.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';

const String SELECT_NULL_APP = "select_null_app";

class SelectAppDialog extends SelectItemDialog<Application> {

  final void Function(Application) onSelected;

  final void Function() onCancel;

  SelectAppDialog({
    required List<Application> list,
    String? selectedApp,
    required this.onSelected,
    required this.onCancel
  }) : super(
    list: list,
    selector: (app) => selectedApp != null && app.packageName == selectedApp
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      TextButton(
        child: Text("设置为空", style: TextStyle(color: Colors.red),),
        onPressed: () async {
          onCancel.call();
          Navigator.pop<String>(context, SELECT_NULL_APP);
        },
      ),
      TextButton(
        child: Text("取消", style: TextStyle(color: Colors.grey)),
        onPressed: () {
          Navigator.pop<String>(context);
        },
      )
    ];
  }

  @override
  Widget buildItem(BuildContext context, Application data) {
    return ListTile(
      title: Text(data.appName),
      subtitle: Text(data.packageName),
      leading: CircleAvatar(
        child: Image.memory((data as ApplicationWithIcon).icon),
      ),
      trailing: selector!.call(data)
          ? Icon(Icons.check, color: Colors.grey,)
          : null,
      onTap: () {
        onSelected(data);
        Navigator.pop<Application>(context, data);
      },
    );
  }

}