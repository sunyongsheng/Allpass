import 'package:allpass/core/di/di.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';
import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/model/api/allpass_response.dart';
import 'package:allpass/core/model/api/feedback_bean.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/common/widget/loading_text_button.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<StatefulWidget> {

  late TextEditingController _feedbackController;
  late TextEditingController _contactController;
  late String _contactCache;

  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _contactCache = AllpassApplication.sp.getString(SPKeys.contact) ?? "";
    _feedbackController = TextEditingController();
    _contactController = TextEditingController(text: _contactCache);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedback, style: AllpassTextUI.titleBarStyle,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: AllpassEdgeInsets.dividerInset,
              height: AllpassScreenUtil.setHeight(500),
              child: NoneBorderCircularTextField(
                editingController: _feedbackController,
                maxLines: 500,
                hintText: l10n.feedbackPlaceholder,
              )
            ),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
            ),
            Container(
              padding: AllpassEdgeInsets.dividerInset,
              child: NoneBorderCircularTextField(
                editingController: _contactController,
                hintText: l10n.feedbackContact,
              )
            ),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
            ),
            Container(
                padding: AllpassEdgeInsets.dividerInset,
                child: LoadingTextButton(
                  title: l10n.submit,
                  color: Theme.of(context).primaryColor,
                  loadingTitle: l10n.submitting,
                  loading: submitting,
                  onPressed: () async {
                    if (_feedbackController.text.trim().length < 1) {
                      ToastUtil.show(msg: l10n.feedbackContentEmptyWarning);
                      return;
                    }
                    if (_feedbackController.text.length >= 1000) {
                      ToastUtil.showError(msg: l10n.feedbackContentTooLong);
                      return;
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                    var result = await submitFeedback();
                    if (result) {
                      Navigator.pop(context);
                    }
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> submitFeedback() async {
    setState(() {
      submitting = true;
    });
    String content = _feedbackController.text;
    String contact = _contactController.text;
    String version = AllpassApplication.version;
    if (_contactController.text.isNotEmpty) {
      AllpassApplication.sp.setString(SPKeys.contact, _contactController.text);
    }
    FeedbackBean feedback = FeedbackBean(content: content, contact: contact, version: version,);
    AllpassResponse response = await inject<AllpassService>().sendFeedback(feedback);
    ToastUtil.show(msg: response.msg!);
    setState(() {
      submitting = false;
    });
    return response.success;
  }

}