import 'package:allpass/application.dart';
import 'package:allpass/core/common_logger.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:flutter/widgets.dart';

class AutofillProvider extends ChangeNotifier {
  var _autofillEnable = false;

  bool get autofillEnable => _autofillEnable;

  Future<void> checkAutofillEnable() async {
    var enable = await AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodIsAppDefaultAutofill);
    commonLogger.i("checkAutofillEnable enable=$enable");
    if (enable != _autofillEnable) {
      _autofillEnable = enable;
      notifyListeners();
    }
  }

  void gotoAutofillSetting() {
    AllpassApplication.methodChannel.invokeMethod(ChannelConstants.methodSetAppDefaultAutofill);
  }
}