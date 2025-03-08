import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';

class AppUpdateManager {
  AppUpdateManager._();

  static void initialize() {
    var lastVersion = AllpassApplication.sp.getString(SPKeys.allpassVersion);
    if (lastVersion == null || lastVersion != AllpassApplication.version) {
      onUpdate(lastVersion, AllpassApplication.version);
    }

    AllpassApplication.sp.setString(SPKeys.allpassVersion, AllpassApplication.version);
  }

  static void onUpdate(String? from, String to) {}
}