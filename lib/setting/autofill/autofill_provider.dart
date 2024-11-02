import 'package:allpass/application.dart';
import 'package:allpass/core/common_logger.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AutofillProvider extends ChangeNotifier {
  var _supportAutofill = false;
  var _autofillEnable = false;

  bool get supportAutofill => _supportAutofill;
  bool get autofillEnable => _autofillEnable;

  Future<void> checkSupportAutofill() async {
    try {
      var support = await AllpassApplication.methodChannel.invokeMethod(
          ChannelConstants.methodSupportAutofill
      );
      if (_supportAutofill != support) {
        _supportAutofill = support;
        notifyListeners();
      }
    } on MissingPluginException {
      // ignore
    }
  }

  Future<void> checkAutofillEnable() async {
    try {
      var enable = await AllpassApplication.methodChannel.invokeMethod(
          ChannelConstants.methodIsAppDefaultAutofill
      );
      commonLogger.i("checkAutofillEnable enable=$enable");
      if (enable != _autofillEnable) {
        _autofillEnable = enable;
        notifyListeners();
      }
    } on MissingPluginException {
      // ignore
    }
  }

  void gotoAutofillSetting() {
    AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodSetAppDefaultAutofill);
  }
}