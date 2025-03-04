import 'dart:math';

import 'package:allpass/application.dart';

class ForceLocker {

  ForceLocker._();

  static final String _lastLockTime = "last_lock_time";

  static final int _lockTimeInSeconds = 30;

  static Future<void> lock() async {
    await AllpassApplication.sp.setInt(_lastLockTime, DateTime.now().millisecondsSinceEpoch);
  }

  static int remainsLockSeconds() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var lockTime = AllpassApplication.sp.getInt(_lastLockTime) ?? 0;
    return max(_lockTimeInSeconds - ((currentTime - lockTime) ~/ 1000), 0);
  }
}