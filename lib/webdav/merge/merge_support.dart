import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/password/model/password_bean.dart';

extension MergeSupport on Object {
  bool mergeIdentify(Object another) {
    if (this is PasswordBean) {
      if (another is PasswordBean) {
        var bean = this as PasswordBean;
        return bean.name == another.name &&
            bean.username == another.username &&
            bean.url == another.url;
      }
    }

    if (this is CardBean) {
      if (another is CardBean) {
        var bean = this as CardBean;
        return bean.name == another.name &&
            bean.ownerName == another.ownerName &&
            bean.cardId == another.cardId &&
            bean.telephone == another.telephone;
      }
    }
    return false;
  }
}