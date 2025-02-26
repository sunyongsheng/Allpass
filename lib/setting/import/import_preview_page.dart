import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ImportPreviewPage extends StatefulWidget {
  final String data;

  const ImportPreviewPage({super.key, required this.data});

  @override
  State createState() {
    return _ImportPreviewState();
  }
}

class _ImportPreviewState extends State<ImportPreviewPage> {

  var _importing = false;
  var _cancel = false;

  @override
  void dispose() {
    super.dispose();
    _cancel = true;
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
                onPressed: () => import(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  void import(BuildContext context) async {
    var l10n = context.l10n;
    if (_importing) {
      ToastUtil.show(msg: l10n.importing);
      return;
    }

    setState(() {
      _importing = true;
    });
    var repository = inject<PasswordRepository>();
    var provider = context.read<PasswordProvider>();
    for (var password in provider.passwordList) {
      if (_cancel) {
        return;
      }

      await repository.create(password);
    }
    ToastUtil.show(msg: l10n.importRecordSuccess(provider.count));
    setState(() {
      _importing = false;
    });
  }
}
