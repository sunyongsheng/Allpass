import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/setting/import/import_base_state.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ImportFromExternalPage extends StatefulWidget {

  const ImportFromExternalPage({super.key});

  @override
  State createState() {
    return _ImportFromExternalState();
  }
}

class _ImportFromExternalState extends ImportBaseState<void> {

  var _importing = false;

  @override
  void initState() {
    super.initState();
    try {
      context.read<PasswordProvider>().init();
    } catch (e) {
      ToastUtil.show(msg: context.l10n.importFailedNotCsv);
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(
          l10n.importFromExternalPreview,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Consumer<PasswordProvider>(
            builder: (context, provider, emptyWidget) {
              if (provider.count == 0) {
                return emptyWidget!;
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var password = provider.passwordList[index];
                    return Slidable(
                      key: Key("${index}_${password.uniqueKey}"),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              provider.deletePassword(password);
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline,
                            label: l10n.delete,
                          ),
                        ],
                      ),
                      child: PasswordWidgetItem(
                        data: password,
                        onPasswordClicked: () {
                          provider.previewPassword(index: index);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: provider,
                                child: ViewPasswordPage(readOnly: true),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: provider.count,
                  physics: const AlwaysScrollableScrollPhysics(),
                );
              }
            },
            child: EmptyDataWidget(title: l10n.emptyDataHint),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: AllpassEdgeInsets.listInset,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: LoadingTextButton(
                title: l10n.confirmImport,
                loading: _importing,
                loadingTitle: l10n.importing,
                color: Theme.of(context).primaryColor,
                onPressed: () => _onTapImport(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTapImport(BuildContext context) async {
    var l10n = context.l10n;
    if (_importing) {
      ToastUtil.show(msg: l10n.importing);
      return;
    }

    setState(() {
      _importing = true;
    });
    await startImport(context, null);
    setState(() {
      _importing = false;
    });
  }

  @override
  Future<bool> importActual(
    BuildContext context,
    void params,
    void Function() ensureNotCancel,
    void Function(double p1) onUpdateProgress,
  ) async {
    var repository = inject<PasswordRepository>();
    var provider = context.read<PasswordProvider>();
    var categoryProvider = context.read<CategoryProvider>();
    var size = provider.count;
    var count = 0;
    for (var password in provider.passwordList) {
      ensureNotCancel();

      await repository.create(password);
      await categoryProvider.addLabel(password.label);
      await categoryProvider.addFolder([password.folder]);
      count++;
      if (size > 0) {
        onUpdateProgress(count / size);
      }
    }
    ToastUtil.show(msg: context.l10n.importRecordSuccess(provider.count));
    return true;
  }
}
