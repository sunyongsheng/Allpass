import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

enum WebDavBackupMethod {
  createNew,
  replaceExists,
}

class WebDavBackupMethods {
  static WebDavBackupMethod? tryParse(String? string) {
    return switch (string) {
      "createNew" => WebDavBackupMethod.createNew,
      "replaceExists" => WebDavBackupMethod.replaceExists,
      _ => null,
    };
  }
}

extension WebDavBackupMethodDesc on WebDavBackupMethod {
  String title(BuildContext context) {
    var l10n = context.l10n;
    return switch (this) {
      WebDavBackupMethod.createNew => l10n.backupMethodCreateNew,
      WebDavBackupMethod.replaceExists => l10n.backupMethodReplaceExists,
    };
  }
}

