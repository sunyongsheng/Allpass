import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/encrypt/encrypt_util.dart';

extension PasswordEncrypt on PasswordBean {
  /// 内存中的PasswordBean password字段始终都是加密的
  ///
  /// 将内存的PasswordBean转为通用的PasswordBean
  PasswordBean encrypt(EncryptLevel targetLevel) {
    switch (targetLevel) {
      // 若目标加密等级为None，则需将password字段进行解密
      case EncryptLevel.None:
        String _password = EncryptUtil.decrypt(this.password);
        return PasswordBean(
          key: this.uniqueKey,
          name: this.name,
          username: this.username,
          password: _password,
          url: this.url,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label),
          fav: this.fav,
          createTime: this.createTime,
          color: this.color,
          sortNumber: this.sortNumber,
          appId: this.appId,
          appName: this.appName,
        );
      // 若目标加密等级为All，则需除password字段字段全部加密
      case EncryptLevel.All:
        String name = EncryptUtil.encrypt(this.name);
        String username = EncryptUtil.encrypt(this.username);
        String url = EncryptUtil.encrypt(this.url.noneDataOrNot());
        String folder = EncryptUtil.encrypt(this.folder);
        String notes = EncryptUtil.encrypt(this.notes.noneDataOrNot());
        List<String> label = [];
        for (String l in this.label) {
          label.add(EncryptUtil.encrypt(l));
        }
        String createTime = EncryptUtil.encrypt(this.createTime);
        String? appId =
            this.appId == null ? null : EncryptUtil.encrypt(this.appId!);
        String? appName =
            this.appName == null ? null : EncryptUtil.encrypt(this.appName!);
        return PasswordBean(
          key: this.uniqueKey,
          name: name,
          username: username,
          password: this.password,
          url: url,
          folder: folder,
          notes: notes,
          label: label,
          fav: this.fav,
          createTime: createTime,
          sortNumber: this.sortNumber,
          color: this.color,
          appId: appId,
          appName: appName,
        );
      // 若目标加密等级为OnlyPassword，则不需做任何操作
      case EncryptLevel.OnlyPassword:
        return PasswordBean(
          key: this.uniqueKey,
          name: this.name,
          username: this.username,
          password: this.password,
          url: this.url,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
          appId: this.appId,
          appName: this.appName,
        );
    }
  }

  /// 将通用的PasswordBean转为内存中的PasswordBean
  PasswordBean decrypt(Encryption customDecryption, EncryptLevel currentLevel) {
    switch (currentLevel) {
      // 若当前加密等级为OnlyPassword，则与内存中PasswordBean相同
      case EncryptLevel.OnlyPassword:
        var password = customDecryption.decrypt(this.password);
        return PasswordBean(
          key: this.uniqueKey,
          name: this.name,
          username: this.username,
          password: EncryptUtil.encrypt(password),
          url: this.url,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
          appId: this.appId,
          appName: this.appName,
        );

      // 若当前加密等级为All，则需将除password以外的字段全部解密
      case EncryptLevel.All:
        String name = customDecryption.decrypt(this.name);
        String username = customDecryption.decrypt(this.username);
        String password = customDecryption.decrypt(this.password);
        String url = customDecryption.decrypt(this.url.noneDataOrNot());
        String folder = customDecryption.decrypt(this.folder);
        String notes = customDecryption.decrypt(this.notes.noneDataOrNot());
        List<String> label = [];
        for (String l in this.label) {
          label.add(customDecryption.decrypt(l));
        }
        String createTime = customDecryption.decrypt(this.createTime);
        String? appId =
            this.appId == null ? null : customDecryption.decrypt(this.appId!);
        String? appName =
            this.appName == null ? null : customDecryption.decrypt(this.appName!);
        return PasswordBean(
          key: this.uniqueKey,
          name: name,
          username: username,
          password: EncryptUtil.encrypt(password),
          url: url,
          folder: folder,
          notes: notes,
          label: label,
          fav: this.fav,
          createTime: createTime,
          sortNumber: this.sortNumber,
          color: this.color,
          appId: appId,
          appName: appName,
        );
      // 若当前加密等级为None，则需将password字段进行加密
      case EncryptLevel.None:
        // 由于此处加密是为了存储，所以使用EncryptUtil
        String _password = EncryptUtil.encrypt(this.password);
        return PasswordBean(
          key: this.uniqueKey,
          name: this.name,
          username: this.username,
          password: _password,
          url: this.url,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label),
          fav: this.fav,
          createTime: this.createTime,
          color: this.color,
          sortNumber: this.sortNumber,
          appId: this.appId,
          appName: this.appName,
        );
    }
  }
}

extension PassowrdList on List<PasswordBean> {
  List<PasswordBean> encrypt(EncryptLevel targetLevel) {
    List<PasswordBean> passwords = [];
    for (var bean in this) {
      passwords.add(bean.encrypt(targetLevel));
    }
    return passwords;
  }

  List<PasswordBean> decrypt(Encryption encryption, EncryptLevel currentLevel) {
    List<PasswordBean> passwords = [];
    for (var bean in this) {
      passwords.add(bean.decrypt(encryption, currentLevel));
    }
    return passwords;
  }
}
