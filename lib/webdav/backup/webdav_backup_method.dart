import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/material.dart';

enum WebDavBackupMethod {
  createNew,
  replaceExists,
}

class WebDavBackupMethods {
  static WebDavBackupMethod? tryParse(String? string) {
    if (string == "createNew") {
      return WebDavBackupMethod.createNew;
    } else if (string == "replaceExists") {
      return WebDavBackupMethod.replaceExists;
    } else {
      return null;
    }
  }
}

extension WebDavBackupMethodDesc on WebDavBackupMethod {
  String title(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case WebDavBackupMethod.createNew:
        return l10n.backupMethodCreateNew;
      case WebDavBackupMethod.replaceExists:
        return l10n.backupMethodReplaceExists;
    }
  }
}

