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
    throw UnsupportedArgumentException("Unsupported value=$value");
  }
}

class MergeMethodItem {
  final MergeMethod method;
  final String desc;

  MergeMethodItem(this.method, this.desc);
}

var mergeMethods = [
  MergeMethodItem(MergeMethod.localFirst, "当本地记录和云端记录名称、用户名和链接相同时，保留本地记录"),
  MergeMethodItem(MergeMethod.remoteFirst, "当本地记录和云端记录名称、用户名和链接相同时，使用云端记录"),
  MergeMethodItem(MergeMethod.onlyRemote, "清空本地所有数据，只使用云端数据"),
];