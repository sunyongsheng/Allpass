import 'dart:convert';

import 'package:allpass/core/enums/allpass_type.dart';

class WebDavCustomBackupFilename {
  final String passwordName;
  final String cardName;
  final String extraName;

  WebDavCustomBackupFilename({
    required this.passwordName,
    required this.cardName,
    required this.extraName,
  });

  String operator [](AllpassType type) {
    switch (type) {
      case AllpassType.password:
        return passwordName;
      case AllpassType.card:
        return cardName;
      case AllpassType.other:
        return extraName;
    }
  }

  static WebDavCustomBackupFilename fromJson(Map<String, dynamic> json) {
    return WebDavCustomBackupFilename(
      passwordName: json["password_filename"],
      cardName: json["card_filename"],
      extraName: json["extra_filename"],
    );
  }

  Map<String, dynamic> toJson() => {
    'password_filename': passwordName,
    'card_filename': cardName,
    'extra_filename': extraName,
  };

  static WebDavCustomBackupFilename? tryParse(String? json) {
    if (json == null) {
      return null;
    }

    return WebDavCustomBackupFilename.fromJson(jsonDecode(json));
  }
}
