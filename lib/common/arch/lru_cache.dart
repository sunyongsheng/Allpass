import 'dart:collection';

import 'dart:math';

class LruCache<K, V> {

  int _maxSize;
  int _size;

  int _putCount;
  int _createCount;
  int _evictionCount;
  int _hitCount;
  int _missCount;
  Map<K, V> _map;

  LruCache({int maxSize}) {
    assert(maxSize == null || maxSize > 0, "maxSize must be greater then 0");
    this._maxSize = maxSize ?? 10;
    _map = LinkedHashMap();
  }

  V get(K key) {
    V mapValue;
    mapValue = _map[key];
    if (mapValue != null) {
      _hitCount++;
      return mapValue;
    }
    _missCount++;

    V createValue = create(key);
    if (createValue == null) {
      return null;
    }

    _createCount++;
    _map.update(key, (value) {
      mapValue = value;
      return createValue;
    }, ifAbsent: () {
      return null;
    });
    if (mapValue != null) {
      _map[key] = mapValue;
    } else {
      _size += 1;
    }

  }

  V create(K key) {
    return null;
  }
}

/// 计算存储次数的容器，[put]的元素次数越多排名越靠前
class SimpleCountCache<T> {

  int _maxSize;
  Map<T, int> _map;

  SimpleCountCache({int maxSize}) {
    assert(maxSize == null || maxSize > 0, "maxSize must be greater then 0");
    this._maxSize = maxSize ?? 10;
    _map = LinkedHashMap();
  }

  void put(T element) {
    if (_map[element] != null) {
      _map[element] += 1;
    } else {
      _map[element] = 1;
    }
  }

  List<T> get({int count}) {
    if (count != null) {
      if (count <= 0) {
        throw ArgumentError("count must be positive!");
      }
      if (count > _maxSize) {
        throw ArgumentError("count can greater than maxSize!");
      }
    } else {
      count = _maxSize;
    }

    var bound = min(min(_map.length, _maxSize), count);
    T currentMaxValue;
    Set<T> res = Set();
    List<T> exs = List();
    for (int index = 0; index < bound; index++) {
      currentMaxValue = _findMaxElement(exclusives: exs);
      exs.add(currentMaxValue);
      res.add(currentMaxValue);
    }
    return res.toList();
  }

  T _findMaxElement({List<T> exclusives}) {
    T maxValue;
    int maxCount = 1;
    _map.forEach((key, value) {
      if (value >= maxCount && !exclusives.contains(key)) {
        maxValue = key;
        maxCount = value;
      }
    });
    return maxValue;
  }

  void clear() {
    _map.clear();
  }
}