import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:installed_apps/app_info.dart';

const String SELECT_NULL_APP = "select_null_app";

class SelectAppDialog extends SelectItemDialog<AppInfo> {

  final void Function(AppInfo) onSelected;

  final void Function() onCancel;

  SelectAppDialog({
    required List<AppInfo> list,
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
        child: Text(context.l10n.setToNone, style: TextStyle(color: Colors.red),),
        onPressed: () async {
          onCancel.call();
          Navigator.pop<String>(context, SELECT_NULL_APP);
        },
      ),
      TextButton(
        child: Text(context.l10n.cancel, style: TextStyle(color: Colors.grey)),
        onPressed: () {
          Navigator.pop<String>(context);
        },
      )
    ];
  }

  @override
  Widget buildItem(BuildContext context, AppInfo data) {
    return ListTile(
      title: Text(data.name),
      subtitle: Text(data.packageName),
      leading: CircleAvatar(
        child: Image.memory(data.icon!),
      ),
      trailing: selector!.call(data)
          ? Icon(Icons.check, color: Colors.grey,)
          : null,
      onTap: () {
        onSelected(data);
        Navigator.pop<AppInfo>(context, data);
      },
    );
  }

}