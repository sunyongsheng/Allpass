import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/webdav/encrypt/encrypt_level.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/encrypt/encrypt_util.dart';

extension CardEncrypt on CardBean {
  /// see [PasswordEncrypt]
  CardBean encrypt(EncryptLevel targetLevel) {
    switch (targetLevel) {
      case EncryptLevel.OnlyPassword:
        return CardBean(
          key: this.uniqueKey,
          name: this.name,
          ownerName: this.ownerName,
          cardId: this.cardId,
          password: this.password,
          telephone: this.telephone,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label ?? []),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );

      case EncryptLevel.All:
        String name = EncryptUtil.encrypt(this.name);
        String ownerName = EncryptUtil.encrypt(this.ownerName);
        String cardId = EncryptUtil.encrypt(this.cardId);
        String telephone = EncryptUtil.encrypt(this.telephone.noneDataOrNot());
        String folder = EncryptUtil.encrypt(this.folder);
        String notes = EncryptUtil.encrypt(this.notes.noneDataOrNot());
        String createTime = EncryptUtil.encrypt(this.createTime);
        List<String> label = [];
        for (String l in this.label ?? []) {
          label.add(EncryptUtil.encrypt(l));
        }
        return CardBean(
          key: this.uniqueKey,
          name: name,
          ownerName: ownerName,
          cardId: cardId,
          password: this.password,
          telephone: telephone,
          folder: folder,
          notes: notes,
          label: label,
          fav: this.fav,
          createTime: createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );

      case EncryptLevel.None:
        String password = EncryptUtil.decrypt(this.password);
        return CardBean(
          key: this.uniqueKey,
          name: this.name,
          ownerName: this.ownerName,
          cardId: this.cardId,
          password: password,
          telephone: this.telephone,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label ?? []),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );
    }
  }

  CardBean decrypt(Encryption customDecryption, EncryptLevel currentLevel) {
    switch (currentLevel) {
      case EncryptLevel.OnlyPassword:
        // 先使用自定义加密工具解密，再使用当前加密类进行加密
        var password = customDecryption.decrypt(this.password);
        return CardBean(
          key: this.uniqueKey,
          name: this.name,
          ownerName: this.ownerName,
          cardId: this.cardId,
          password: EncryptUtil.encrypt(password),
          telephone: this.telephone,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label ?? []),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );

      case EncryptLevel.All:
        String name = customDecryption.decrypt(this.name);
        String ownerName = customDecryption.decrypt(this.ownerName);
        String cardId = customDecryption.decrypt(this.cardId);
        String telephone = customDecryption.decrypt(this.telephone.noneDataOrNot());
        String folder = customDecryption.decrypt(this.folder);
        String notes = customDecryption.decrypt(this.notes.noneDataOrNot());
        String createTime = customDecryption.decrypt(this.createTime);
        List<String> label = [];
        for (String l in this.label ?? []) {
          label.add(customDecryption.decrypt(l));
        }
        return CardBean(
          key: this.uniqueKey,
          name: name,
          ownerName: ownerName,
          cardId: cardId,
          password: this.password,
          telephone: telephone,
          folder: folder,
          notes: notes,
          label: label,
          fav: this.fav,
          createTime: createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );

      case EncryptLevel.None:
        // 由于此处加密是为了存储，因此使用EncryptUtil
        String password = EncryptUtil.encrypt(this.password);
        return CardBean(
          key: this.uniqueKey,
          name: this.name,
          ownerName: this.ownerName,
          cardId: this.cardId,
          password: password,
          telephone: this.telephone,
          folder: this.folder,
          notes: this.notes,
          label: List.from(this.label ?? []),
          fav: this.fav,
          createTime: this.createTime,
          sortNumber: this.sortNumber,
          color: this.color,
        );
    }
  }
}

extension CardList on List<CardBean> {
  List<CardBean> encrypt(EncryptLevel targetLevel) {
    List<CardBean> cards = [];
    for (var bean in this) {
      cards.add(bean.encrypt(targetLevel));
    }
    return cards;
  }

  List<CardBean> decrypt(Encryption encryption, EncryptLevel currentLevel) {
    List<CardBean> cards = [];
    for (var bean in this) {
      cards.add(bean.decrypt(encryption, currentLevel));
    }
    return cards;
  }
}
