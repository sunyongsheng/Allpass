import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/core/enums/encrypt_level.dart';
import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/util/encrypt_util.dart';

extension CardEncrypter on CardBean {
  CardBean encrypt(EncryptLevel level) {
    switch (level) {
      case EncryptLevel.None:
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
            color: this.color);

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
            color: this.color);

      default:
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
            color: this.color);
    }
  }
}

extension CardList on List<CardBean> {
  List<CardBean> encrypt(EncryptLevel level) {
    List<CardBean> cards = [];
    for (var bean in this) {
      cards.add(bean.encrypt(level));
    }
    return cards;
  }
}
