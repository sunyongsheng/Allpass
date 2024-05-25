import 'package:allpass/core/model/identifiable.dart';

extension MergeSupport<T extends Object> on Object {
  bool mergeIdentify(Object another) {
    if (this is Identifiable<T> && another is Identifiable<T>) {
      return (this as Identifiable<T>).identify(another as T);
    }
    return this == another;
  }
}
