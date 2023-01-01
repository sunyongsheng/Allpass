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
          if (provider.backupFilesRefreshing) {
            children.add(child!);
          }

          provider.backupFiles.forEach((file) {
            IconData icon;
            if (file.isFile) {
              icon = Icons.file_present_rounded;
            } else {
              icon = Icons.folder_open_rounded;
            }
            children.add(ListTile(
              leading: Icon(icon),
              title: Text(file.filename),
              subtitle: Text(DateFormatter.format(file.lastModified)),
              onTap: () {
                Navigator.pop(context, file.filename);
                widget.onSelect.call(file.filename);
              },
            ));
          });

          if (children.length == 1) {

          }
          return Column(
            children: children,
          );
        },
        child: Padding(
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
        ),
      ),
    );
  }
}