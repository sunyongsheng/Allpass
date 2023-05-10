import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/cupertino.dart';

enum MergeMethod {
  localFirst,
  remoteFirst,
  onlyRemote
}

extension MergeMethodExt on MergeMethod {
  String title(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case MergeMethod.localFirst:
        return l10n.mergeMethodLocalFirst;
      case MergeMethod.remoteFirst:
        return l10n.mergeMethodRemoteFirst;
      case MergeMethod.onlyRemote:
        return l10n.mergeMethodOnlyRemote;
    }
  }

  String desc(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case MergeMethod.localFirst:
        return l10n.mergeMethodLocalFirstHelp;
      case MergeMethod.remoteFirst:
        return l10n.mergeMethodRemoteFirstHelp;
      case MergeMethod.onlyRemote:
        return l10n.mergeMethodOnlyRemoteHelp;
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

var mergeMethods = [
  MergeMethod.localFirst,
  MergeMethod.remoteFirst,
  MergeMethod.onlyRemote,
];