import 'package:device_apps/device_apps.dart';
import 'package:lpinyin/lpinyin.dart';

class DeviceAppsHolder {

  DeviceAppsHolder._();

  static List<Application>? _cache;

  static Future<List<Application>> getInstalledApps() async {
    if (_cache == null) {
      var list = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
      );
      list.sort((a, b) {
        return PinyinHelper.getShortPinyin(a.appName).toLowerCase()
            .compareTo(PinyinHelper.getShortPinyin(b.appName).toLowerCase());
      });
      _cache = list;
      return list;
    }
    return _cache!;
  }
}