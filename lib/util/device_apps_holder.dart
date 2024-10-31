import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:lpinyin/lpinyin.dart';

class DeviceAppsHolder {

  DeviceAppsHolder._();

  static List<AppInfo>? _cache;

  static Future<List<AppInfo>> getInstalledApps() async {
    if (_cache == null || _cache?.isEmpty == true) {
      var list = await InstalledApps.getInstalledApps(true, true);
      list.sort((a, b) {
        return PinyinHelper.getShortPinyin(a.name).toLowerCase()
            .compareTo(PinyinHelper.getShortPinyin(b.name).toLowerCase());
      });
      _cache = list;
      return list;
    }
    return _cache!;
  }
}