import 'package:allpass/common/widget/progress_dialog.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/import/import_exceptions.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/material.dart';

abstract class ImportBaseState<PARAMS> extends State<StatefulWidget> {

  var _isShowingProgressDialog = false;
  var _canceled = false;

  @override
  void dispose() {
    super.dispose();
    _canceled = true;
  }

  Future<void> startImport(BuildContext context, PARAMS params) async {
    _isShowingProgressDialog = true;
    return showDialog(
      context: context,
      builder: (cx) => ProgressDialog(
        runningHint: context.l10n.importing,
        completeHint: context.l10n.importComplete,
        execution: (onUpdateProgress) async {
          var future = _executeImport(
            context,
            params,
            () {
              if (_canceled) {
                throw ImportCancellationException();
              }
            },
            onUpdateProgress,
          );
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
        _canceled = true;
      }
      _isShowingProgressDialog = false;
    });
  }

  Future<bool> _executeImport(
    BuildContext context,
    PARAMS params,
    void Function() ensureNotCancel,
    void Function(double) onUpdateProgress,
  ) async {
    _canceled = false;
    onUpdateProgress(0);
    try {
      return await importActual(context, params, ensureNotCancel, onUpdateProgress);
    } on ImportCancellationException {
      ToastUtil.show(msg: context.l10n.importCanceled);
    } catch (_) {
      ToastUtil.showError(msg: context.l10n.importFailedNotCsv);
    }
    return false;
  }

  Future<bool> importActual(
    BuildContext context,
    PARAMS params,
    void Function() ensureNotCancel,
    void Function(double) onUpdateProgress,
  );
}