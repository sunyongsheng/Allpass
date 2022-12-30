import 'package:allpass/core/enums/encrypt_level.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/encrypt_util.dart';

extension PasswordEncrypter on PasswordBean {
  PasswordBean encrypt(EncryptLevel level) {
    switch (level) {
      case EncryptLevel.OnlyPassword:
        String _password = EncryptUtil.decrypt(this.password);
        return PasswordBean(
            key: this.uniqueKey,
            name: this.name,
            username: this.username,
            password: _password,
            url: this.url,
            folder: this.folder,
            notes: this.notes,
            label: List.from(this.label ?? []),
            fav: this.fav,
            createTime: this.createTime,
            color: this.color,
            sortNumber: this.sortNumber,
            appId: this.appId,
            appName: this.appName);

      case EncryptLevel.All:
        String name = EncryptUtil.encrypt(this.name);
        String username = EncryptUtil.encrypt(this.username);
        String url = EncryptUtil.encrypt(this.url.noneDataOrNot());
        String folder = EncryptUtil.encrypt(this.folder);
        String notes = EncryptUtil.encrypt(this.notes.noneDataOrNot());
        List<String> label = [];
        for (String l in this.label ?? []) {
          label.add(EncryptUtil.encrypt(l));
        }
        String createTime = EncryptUtil.encrypt(this.createTime);
        String? appId = this.appId == null ? null : EncryptUtil.encrypt(this.appId!);
        String? appName = this.appName == null ? null : EncryptUtil.encrypt(this.appName!);
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
            appName: appName);

      default:
        return PasswordBean(
            key: this.uniqueKey,
            name: this.name,
            username: this.username,
            password: this.password,
            url: this.url,
            folder: this.folder,
            notes: this.notes,
            label: List.from(this.label ?? []),
            fav: this.fav,
            createTime: this.createTime,
            sortNumber: this.sortNumber,
            color: this.color,
            appId: this.appId,
            appName: this.appName);
    }
  }
}

extension PassowrdList on List<PasswordBean> {
  List<PasswordBean> encrypt(EncryptLevel level) {
    List<PasswordBean> passwords = [];
    for (var bean in this) {
      passwords.add(bean.encrypt(level));
    }
    return passwords;
  }
}
