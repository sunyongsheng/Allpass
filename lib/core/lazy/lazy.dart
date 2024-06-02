abstract class Lazy<T extends Object> {
  T get value;
}

class LazyImpl<T extends Object> implements Lazy<T> {
  T? _value;
  final T Function() _creator;

  LazyImpl(this._creator);

  @override
  T get value {
    if (_value == null) {
      _value = _creator();
    }
    return _value!;
  }
}

Lazy<T> lazy<T extends Object>(T Function() creator) {
  return LazyImpl(creator);
}