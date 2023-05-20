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
    return switch (this) {
      CategoryType.folder => l10n.folderTitle,
      CategoryType.label => l10n.labels,
    };
  }

  String title(BuildContext context) {
    var l10n = context.l10n;
    return switch (this) {
      CategoryType.folder => l10n.folder,
      CategoryType.label => l10n.label,
    };
  }
}
