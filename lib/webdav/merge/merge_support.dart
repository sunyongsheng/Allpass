import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';

extension MergeSupport on Object {
  bool mergeIdentify(Object another) {
    if (this is PasswordBean) {
      if (another is PasswordBean) {
        var bean = this as PasswordBean;
        return bean.identify(another);
      }
    }

    if (this is CardBean) {
      if (another is CardBean) {
        var bean = this as CardBean;
        return bean.identify(another);
      }
    }
    return false;
  }
}

extension CardBeanMergeSupport on CardBean {
  bool identify(CardBean another) {
    return this.name == another.name &&
        this.ownerName == another.ownerName &&
        this.cardId == another.cardId;
  }
}

extension PasswordBeanMergeSupport on PasswordBean {
  bool identify(PasswordBean another) {
    return this.name == another.name &&
        this.username == another.username &&
        this.url == another.url;
  }
}