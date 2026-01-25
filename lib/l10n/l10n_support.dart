import 'package:flutter/cupertino.dart';

import 'app_localizations.dart';

extension L10nSupport on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}