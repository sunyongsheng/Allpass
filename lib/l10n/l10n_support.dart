import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension L10nSupport on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}