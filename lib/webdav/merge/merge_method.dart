import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/cupertino.dart';

enum MergeMethod {
  localFirst,
  remoteFirst,
  onlyRemote;

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

extension MergeMethodExt on MergeMethod {
  String title(BuildContext context) {
    var l10n = context.l10n;
    return switch (this) {
      MergeMethod.localFirst => l10n.mergeMethodLocalFirst,
      MergeMethod.remoteFirst => l10n.mergeMethodRemoteFirst,
      MergeMethod.onlyRemote => l10n.mergeMethodOnlyRemote,
    };
  }

  String desc(BuildContext context) {
    var l10n = context.l10n;
    return switch (this) {
      MergeMethod.localFirst => l10n.mergeMethodLocalFirstHelp,
      MergeMethod.remoteFirst => l10n.mergeMethodRemoteFirstHelp,
      MergeMethod.onlyRemote => l10n.mergeMethodOnlyRemoteHelp,
    };
  }
}

var mergeMethods = [
  MergeMethod.localFirst,
  MergeMethod.remoteFirst,
  MergeMethod.onlyRemote,
];