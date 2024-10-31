import 'dart:io';

import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class OldDatabaseMigration {

  static final String _tag = "OldDatabaseMigration";

  var _logger = Logger();

  Future<bool> needMigration() async {
    if (!Platform.isAndroid) {
      _logger.d("$_tag current platform is not Android");
      return false;
    }

    String path = await _getOldDatabasePath();
    return File(path).exists();
  }

  Future<String> migrate(String dbPath) async {
    _logger.i("$_tag begin database migration");

    var oldPath = await _getOldDatabasePath();
    var oldDbFile = File(oldPath);
    var oldDbFileJournal = File(oldPath + "-journal");
    var success = false;
    try {
      if (await oldDbFile.exists()) {
        await oldDbFile.copy(dbPath);
      }
      if (await oldDbFileJournal.exists()) {
        await oldDbFileJournal.copy(dbPath + "-journal");
      }
      success = true;
    } catch (e) {
      _logger.e("$_tag migrate error", error: e);
    }
    _logger.i("$_tag database migration result=$success");
    if (success) {
      if (await oldDbFile.exists()) {
        await oldDbFile.delete();
      }
      if (await oldDbFileJournal.exists()) {
        await oldDbFileJournal.delete();
      }
      return dbPath;
    }
    return oldPath;
  }

  Future<String> _getOldDatabasePath() async {
    var dbPath = await getDatabasesPath();
    return dbPath + "allpass_db";
  }

}