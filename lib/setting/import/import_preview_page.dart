import 'package:allpass/common/ui/allpass_ui.dart';
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
            builder: (context, provider, _) => ListView.builder(
              itemBuilder: (context, index) {
                return PasswordWidgetItem(
                  data: provider.passwordList[index],
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
                );
              },
              itemCount: provider.count,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: AllpassEdgeInsets.listInset,
              color: Colors.white,
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
      await repository.create(password);
    }
    ToastUtil.show(msg: l10n.importRecordSuccess(provider.count));
    setState(() {
      _importing = false;
    });
  }
}
