import 'package:allpass/core/param/config.dart';
import 'package:allpass/l10n/l10n_support.dart';
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
      context.read<WebDavSyncProvider>().refreshFiles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.selectBackupFile),
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
                      l10n.gettingBackupFiles,
                      style: Theme.of(context).textTheme.bodySmall,
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
                style: Theme.of(context).textTheme.bodySmall,
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
                l10n.noBackupFileHint,
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
            l10n.currentDirectory(Config.webDavBackupDirectory),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}