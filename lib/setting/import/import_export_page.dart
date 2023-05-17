import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/ui/icon_resource.dart';
import 'package:allpass/setting/import/import_from_chrome_page.dart';
import 'package:allpass/setting/import/import_from_clipboard_page.dart';
import 'package:allpass/setting/import/import_from_csv_page.dart';
import 'package:allpass/setting/import/export_to_csv_page.dart';
import 'package:provider/provider.dart';

/// 导入导出页面
class ImportExportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.importExport,
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
        ),
        backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: AllpassEdgeInsets.smallTopInsets,
            ),

            Card(
              margin: AllpassEdgeInsets.settingCardInset,
              elevation: 0,
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.importFromChrome),
                    leading: Icon(CustomIcons.chrome, color: AllpassColorUI.allColor[6]),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ImportFromChromePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(l10n.importFromCsv),
                    leading: Icon(Icons.import_contacts, color: AllpassColorUI.allColor[4]),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ImportFromCsvPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(l10n.importFromClipboard),
                    leading: Icon(Icons.content_paste, color: AllpassColorUI.allColor[1]),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ImportFromClipboardPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Card(
              margin: AllpassEdgeInsets.settingCardInset,
              elevation: 0,
              child: ListTile(
                title: Text(l10n.exportToCsv),
                leading: Icon(Icons.call_missed_outgoing, color: AllpassColorUI.allColor[3]),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ExportTypeSelectPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
