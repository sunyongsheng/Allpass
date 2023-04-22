import 'package:allpass/core/error/app_error.dart';

enum MergeMethod {
  localFirst,
  remoteFirst,
  onlyRemote
}

extension MergeMethodExt on MergeMethod {
  String get name {
    switch (this) {
      case MergeMethod.localFirst:
        return "本地优先";
      case MergeMethod.remoteFirst:
        return "云端优先";
      case MergeMethod.onlyRemote:
        return "不保留本地数据";
    }
  }
}

class MergeMethods {
  static MergeMethod parse(int value) {
    for (var method in MergeMethod.values) {
      if (method.index == value) {
        return method;
      }
    }
    throw UnsupportedEnumException("Unsupported value=$value");
  }

  static MergeMethod? tryParse(int? value) {
    if (value == null) return null;
    try {
      return parse(value);
    } catch (_) {
      return null;
    }
  }
}

class MergeMethodItem {
  final MergeMethod method;
  final String desc;

  const MergeMethodItem(this.method, this.desc);
}

var mergeMethods = [
  const MergeMethodItem(MergeMethod.localFirst, "当本地记录和云端记录名称、用户名和链接相同时，保留本地记录"),
  const MergeMethodItem(MergeMethod.remoteFirst, "当本地记录和云端记录名称、用户名和链接相同时，使用云端记录"),
  const MergeMethodItem(MergeMethod.onlyRemote, "清空本地所有数据，只使用云端数据"),
];