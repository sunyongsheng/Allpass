import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:flutter/widgets.dart';

import '../../../encrypt/encrypt_util.dart';

enum ContentFormatType {
  nameAccountPasswordUrl,
  nameAccountPassword,
  accountPasswordUrl,
  accountPassword,
  namePassword,
  password;
}

extension ContentFormatTypeDesc on ContentFormatType {
  String l10n(BuildContext context) {
    switch (this) {
      case ContentFormatType.nameAccountPasswordUrl:
        return context.l10n.importFromClipboardFormat1;
      case ContentFormatType.nameAccountPassword:
        return context.l10n.importFromClipboardFormat2;
      case ContentFormatType.accountPasswordUrl:
        return context.l10n.importFromClipboardFormat3;
      case ContentFormatType.accountPassword:
        return context.l10n.importFromClipboardFormat4;
      case ContentFormatType.namePassword:
        return context.l10n.importFromClipboardFormat5;
      case ContentFormatType.password:
        return context.l10n.importFromClipboardFormat6;
    }
  }
}

sealed class ContentParserParams {}

class EmptyContentParserParams extends ContentParserParams {
  EmptyContentParserParams._();
  static final EmptyContentParserParams instance = EmptyContentParserParams._();
}

class AccountContentParserParams extends ContentParserParams {
  final String account;
  AccountContentParserParams(this.account);
}

abstract class ContentParser<T extends ContentParserParams> {

  PasswordBean? parse(String content, {ContentParserParams? params,}) {
    if (content.isEmpty) {
      return null;
    }

    var finalParams = params ?? EmptyContentParserParams.instance;
    var fields = content
        .split(" ")
        .where((value) => value.isNotEmpty)
        .toList();
    bool valid = fields.length == requiredColumns && finalParams is T;
    if (!valid) {
      return null;
    }

    return as(fields, finalParams);
  }

  ContentFormatType get type;

  int get requiredColumns;

  PasswordBean? as(List<String> fields, T params);

  static ContentParser of(ContentFormatType type) {
    ContentParser formatter;
    switch (type) {
      case ContentFormatType.nameAccountPasswordUrl:
        formatter = _ContentParser1();
        break;
      case ContentFormatType.nameAccountPassword:
        formatter = _ContentParser2();
        break;
      case ContentFormatType.accountPasswordUrl:
        formatter = _ContentParser3();
        break;
      case ContentFormatType.accountPassword:
        formatter = _ContentParser4();
        break;
      case ContentFormatType.namePassword:
        formatter = _ContentParser5();
        break;
      case ContentFormatType.password:
        formatter = _ContentParser6();
        break;
    }
    assert(formatter.type == type);
    return formatter;
  }
}

class _ContentParser1 extends ContentParser<EmptyContentParserParams> {

  @override
  ContentFormatType get type => ContentFormatType.nameAccountPasswordUrl;

  @override
  int get requiredColumns => 4;

  @override
  PasswordBean? as(List<String> fields, EmptyContentParserParams params) {
    return PasswordBean(
      name: fields[0],
      username: fields[1],
      password: EncryptUtil.encrypt(fields[2]),
      url: fields[3],
    );
  }
}

class _ContentParser2 extends ContentParser<EmptyContentParserParams> {
  @override
  ContentFormatType get type => ContentFormatType.nameAccountPassword;

  @override
  int get requiredColumns => 3;

  @override
  PasswordBean? as(List<String> fields, EmptyContentParserParams params) {
    return PasswordBean(
      name: fields[0],
      username: fields[1],
      password: EncryptUtil.encrypt(fields[2]),
      url: "",
    );
  }
}

class _ContentParser3 extends ContentParser<EmptyContentParserParams> {
  @override
  ContentFormatType get type => ContentFormatType.accountPasswordUrl;

  @override
  int get requiredColumns => 3;

  @override
  PasswordBean? as(List<String> fields, EmptyContentParserParams params) {
    return PasswordBean(
      name: fields[0],
      username: fields[0],
      password: EncryptUtil.encrypt(fields[1]),
      url: fields[2],
    );
  }
}

class _ContentParser4 extends ContentParser<EmptyContentParserParams> {
  @override
  ContentFormatType get type => ContentFormatType.accountPassword;

  @override
  int get requiredColumns => 2;

  @override
  PasswordBean? as(List<String> fields, EmptyContentParserParams params) {
    return PasswordBean(
      name: fields[0],
      username: fields[0],
      password: EncryptUtil.encrypt(fields[1]),
      url: "",
    );
  }
}

class _ContentParser5 extends ContentParser<AccountContentParserParams> {
  @override
  ContentFormatType get type => ContentFormatType.namePassword;

  @override
  int get requiredColumns => 2;

  @override
  PasswordBean? as(List<String> fields, AccountContentParserParams params) {
    return PasswordBean(
      name: fields[0],
      username: params.account,
      password: EncryptUtil.encrypt(fields[1]),
      url: "",
    );
  }
}

class _ContentParser6 extends ContentParser<AccountContentParserParams> {
  @override
  ContentFormatType get type => ContentFormatType.password;

  @override
  int get requiredColumns => 1;

  @override
  PasswordBean? as(List<String> fields, AccountContentParserParams params) {
    return PasswordBean(
      name: params.account,
      username: params.account,
      password: EncryptUtil.encrypt(fields[0]),
      url: "",
    );
  }
}

