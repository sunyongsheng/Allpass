import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/date_formatter.dart';
import 'package:allpass/webdav/ui/webdav_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectBackupFileDialog extends StatefulWidget {

  final void Function(String) onSelect;

  const SelectBackupFileDialog({Key? key, required this.onSelect}) : super(key: key);

  @override
  State createState() {
    return _SelectBackupFileState();
  }
}

class _SelectBackupFileState extends State<SelectBackupFileDialog> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WebDavSyncProvider>().refreshFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("选择备份文件"),
      scrollable: true,
      content: Consumer<WebDavSyncProvider>(
        builder: (context, provider, child) {
          var children = <Widget>[];
          children.add(child!);

          var state = provider.getBackupFileState;
          if (state is GettingBackupFile) {
            children.add(Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "获取备份文件中，请稍后...",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                ],
              ),
            ));
          } else if (state is GetBackupFileFail) {
            children.add(Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.caption,
              ),
            ));
          }

          provider.backupFiles.forEach((file) {
            children.add(ListTile(
              title: Text(file.filename),
              subtitle: Text(DateFormatter.format(file.lastModified)),
              onTap: () {
                Navigator.pop(context, file.filename);
                widget.onSelect.call(file.filename);
              },
            ));
          });

          if (state is GetBackupFileSuccess && provider.backupFiles.isEmpty) {
            children.add(Center(
              child: Text(
                "当前目录下无文件，请确保备份目录正确",
              ),
            ));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "当前目录：${Config.webDavBackupDirectory}",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
    );
  }
}