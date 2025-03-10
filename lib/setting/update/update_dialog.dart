import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/core/model/api/update_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';

class UpdateDialog extends StatelessWidget {

  final Key? key;
  final UpdateBean updateBean;

  UpdateDialog(this.updateBean, {this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.checkUpdate),
      content: SingleChildScrollView(child: _createUpdateContent(context)),
      actions: _createUpdateAction(context)
    );
  }

  Widget _createUpdateContent(BuildContext context) {
    var l10n = context.l10n;
    String _updateContent = updateBean.updateContent?.replaceAll("~", "\n") ?? l10n.none;
    switch (updateBean.checkResult) {
      case CheckUpdateResult.HaveUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.updateAvailable(updateBean.channel, updateBean.version)),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text(
                l10n.updateContent,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(_updateContent)
          ],
        );
      case CheckUpdateResult.NoUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.alreadyLatestVersion(updateBean.channel, updateBean.version)),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text(
                l10n.recentlyUpdateContent,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(_updateContent)
          ],
        );
      case CheckUpdateResult.NetworkError:
        _updateContent = l10n.networkErrorMsg(updateBean.updateContent);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.networkErrorHelp),
            Text(_updateContent)
          ],
        );
      default:
        _updateContent = l10n.unknownError(updateBean.updateContent);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.unknownErrorHelp),
            Text(_updateContent)
          ],
        );
    }
  }

  List<Widget> _createUpdateAction(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    var l10n = context.l10n;
    if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
      return [
        TextButton(
          child: Text(
            l10n.downloadUpdate,
            style: TextStyle(color: mainColor),
          ),
          onPressed: () async {
            String? downloadUrl = updateBean.downloadUrl;
            if (downloadUrl != null) {
              await launchUrl(
                Uri.parse(downloadUrl),
                mode: LaunchMode.externalApplication,
              );
            }
          },
        ),
        TextButton(
          child: Text(
            l10n.remindMeLatter,
            style: TextStyle(color: mainColor),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ];
    } else {
      return [
        TextButton(
          child: Text(l10n.confirm, style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(l10n.cancel, style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop(context),
        )
      ];
    }
  }
}