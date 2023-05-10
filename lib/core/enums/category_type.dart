import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/widgets.dart';

/// 属性类型，包括文件夹与标签
enum CategoryType {
  folder,
  label,
}

extension CategoryTitle on CategoryType {
  String titles(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case CategoryType.folder:
        return l10n.folderTitle;
      case CategoryType.label:
        return l10n.labels;
    }
  }

  String title(BuildContext context) {
    var l10n = context.l10n;
    switch (this) {
      case CategoryType.folder:
        return l10n.folder;
      case CategoryType.label:
        return l10n.label;
    }
  }
}
