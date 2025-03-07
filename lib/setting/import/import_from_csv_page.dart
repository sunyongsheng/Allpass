import 'dart:async';

import 'package:allpass/application.dart';
import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/common/widget/progress_dialog.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/import/import_exceptions.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/toast_util.dart';

class ImportFromCsvPage extends StatefulWidget {
  @override
  State createState() {
    return _ImportFromCsvPageState();
  }
}

class _ImportFromCsvPageState extends State<ImportFromCsvPage> {

  var _isShowingProgressDialog = false;
  var _cancel = false;

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectImportType,
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
            child: ListTile(
              title: Text(l10n.password),
              leading: Icon(
                Icons.supervised_user_circle,
                color: AllpassColorUI.allColor[0],
              ),
              onTap: () async => await _onTap(AllpassType.password),
            ),
          ),

          Card(
            margin: AllpassEdgeInsets.settingCardInset,
            elevation: 0,
            child: ListTile(
              title: Text(l10n.card),
              leading: Icon(
                Icons.credit_card,
                color: AllpassColorUI.allColor[1],
              ),
              onTap: () async => await _onTap(AllpassType.card),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(AllpassType type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv']
      );
      _showProgressDialog(context, type, result?.files.single.path);
    } on PlatformException catch (e) {
      if (e.code == "read_external_storage_denied") {
        ToastUtil.showError(msg: context.l10n.storagePermissionDenied);
        await AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodOpenAppSettingsPage);
      }
    }
  }

  void _showProgressDialog(BuildContext context, AllpassType type, String? path) {
    if (path == null) {
      return;
    }

    _isShowingProgressDialog = true;
    showDialog(
      context: context,
      builder: (cx) => ProgressDialog(
        runningHint: context.l10n.importing,
        completeHint: context.l10n.importComplete,
        execution: (onUpdateProgress) async {
          var future = importActual(context, type, path, onUpdateProgress);
          future.then((_) =>
              Future.delayed(Duration(milliseconds: 500), () {
                if (_isShowingProgressDialog) {
                  Navigator.pop(context, true);
                }
              }),
          );
          return future;
        },
      ),
    ).then((result) {
      if (result != true) {
        _cancel = true;
      }
      _isShowingProgressDialog = false;
    });
  }

  Future<bool> importActual(BuildContext context, AllpassType type, String path, void Function(double) onUpdateProgress) async {
    _cancel = false;
    onUpdateProgress(0);
    try {
      var categoryProvider = context.read<CategoryProvider>();
      if (type == AllpassType.password) {
        var passwordProvider = context.read<PasswordProvider>();
        List<PasswordBean> passwordList = await CsvUtil.parsePasswordFromCsv(path: path);
        var size = passwordList.length;
        var count = 0;
        for (var bean in passwordList) {
          if (_cancel) {
            throw ImportCancellationException();
          }

          await passwordProvider.insertPassword(bean);
          await categoryProvider.addLabel(bean.label);
          await categoryProvider.addFolder([bean.folder]);
          count++;
          if (size > 0) {
            onUpdateProgress(count / size);
          }
        }
        ToastUtil.show(msg: context.l10n.importRecordSuccess(passwordList.length));
        await passwordProvider.refresh();
      } else if (type == AllpassType.card) {
        var cardProvider = context.read<CardProvider>();
        List<CardBean> cardList = await CsvUtil.cardImportFromCsv(path) ?? [];
        var size = cardList.length;
        var count = 0;
        for (var bean in cardList) {
          if (_cancel) {
            throw ImportCancellationException();
          }

          await cardProvider.insertCard(bean);
          await categoryProvider.addLabel(bean.label);
          await categoryProvider.addFolder([bean.folder]);
          count++;
          if (size > 0) {
            onUpdateProgress(count / size);
          }
        }
        ToastUtil.show(msg: context.l10n.importRecordSuccess(cardList.length));
        await cardProvider.refresh();
      } else {
        throw UnsupportedImportException();
      }
      return true;
    } on ImportCancellationException {
      ToastUtil.show(msg: context.l10n.importCanceled);
    } catch (_) {
      ToastUtil.showError(msg: context.l10n.importFailedNotCsv);
    }
    return false;
  }
}
