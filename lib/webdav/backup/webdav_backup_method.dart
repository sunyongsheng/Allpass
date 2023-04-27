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
  String get desc {
    switch (this) {
      case WebDavBackupMethod.createNew:
        return "每次创建新文件";
      case WebDavBackupMethod.replaceExists:
        return "备份到指定文件";
    }
  }
}

class WebDavBackupMethodItem {
  final WebDavBackupMethod method;
  final String name;

  WebDavBackupMethodItem(this.method, this.name);
}

var backupMethods = WebDavBackupMethod.values
    .map((e) => WebDavBackupMethodItem(e, e.desc))
    .toList();
