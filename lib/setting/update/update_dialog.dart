import 'package:allpass/application.dart';
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
    String _updateContent = updateBean.updateContent?.replaceAll("~", "\n") ?? context.l10n.none;
    switch (updateBean.checkResult) {
      case CheckUpdateResult.HaveUpdate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(context.l10n.updateAvailable(updateBean.channel, updateBean.version)),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text(
                context.l10n.updateContent,
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
            Text(context.l10n.alreadyLatestVersion(updateBean.channel, updateBean.version)),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
              child: Text(
                context.l10n.recentlyUpdateContent,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(_updateContent)
          ],
        );
      case CheckUpdateResult.NetworkError:
        _updateContent = context.l10n.networkErrorMsg(updateBean.updateContent);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(context.l10n.networkErrorHelp),
            Text(_updateContent)
          ],
        );
      default:
        _updateContent = context.l10n.unknownError(updateBean.updateContent);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(context.l10n.unknownErrorHelp),
            Text(_updateContent)
          ],
        );
    }
  }

  List<Widget> _createUpdateAction(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    if (updateBean.checkResult == CheckUpdateResult.HaveUpdate) {
      return [
        TextButton(
          child: Text(
            context.l10n.downloadUpdate,
            style: TextStyle(color: mainColor),
          ),
          onPressed: () async {
            String? downloadUrl;
            if (updateBean.isBetaChannel()) {
              downloadUrl = "${updateBean.downloadUrl}&identification=${AllpassApplication.identification}";
            } else {
              downloadUrl = updateBean.downloadUrl;
            }
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
            context.l10n.remindMeLatter,
            style: TextStyle(color: mainColor),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ];
    } else {
      return [
        TextButton(
          child: Text(context.l10n.confirm, style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(context.l10n.cancel, style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop(context),
        )
      ];
    }
  }
}