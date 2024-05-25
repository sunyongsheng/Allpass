import 'package:allpass/core/model/identifiable.dart';
import 'package:allpass/webdav/merge/merge_support.dart';
import 'package:flutter_test/flutter_test.dart';

class Identifier1 {
  int id;

  Identifier1(this.id);

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  int get hashCode => identityHashCode(this);
}

class Identifier2 implements Identifiable<Identifier2> {

  int id;

  Identifier2(this.id);

  @override
  bool identify(Identifier2 other) {
    return id == other.id;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  int get hashCode => identityHashCode(this);

}

void main() {
  test("merge_support_test", () {
    var a = Identifier1(1);
    var b = Identifier1(1);
    var c = Identifier1(2);
    assert(!a.mergeIdentify(b));
    assert(!a.mergeIdentify(c));

    var d = Identifier2(1);
    var e = Identifier2(1);
    var f = Identifier2(2);
    assert(d.mergeIdentify(e));
    assert(!d.mergeIdentify(f));
  });
}