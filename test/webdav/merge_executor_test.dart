import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/webdav/merge/merge_executors.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // password3与password8互斥
  var password1 =
      PasswordBean(name: "name1", username: "username1", password: "111");
  var password2 =
      PasswordBean(name: "name2", username: "username2", password: "222");
  var password3 =
      PasswordBean(name: "name3", username: "username3", password: "333");
  var password4 =
      PasswordBean(name: "name4", username: "username4", password: "444");
  var password5 =
      PasswordBean(name: "name5", username: "username5", password: "555");
  var password6 =
      PasswordBean(name: "name6", username: "username6", password: "666");

  var password7 =
      PasswordBean(name: "name2", username: "username3", password: "777");
  var password8 =
      PasswordBean(name: "name3", username: "username3", password: "888");
  var password9 =
      PasswordBean(name: "name8", username: "username6", password: "999");

  test("Merge Executor Test", () async {
    List<PasswordBean> localList = [
      password1,
      password2,
      password3,
      password4,
      password5,
      password6,
    ];

    List<PasswordBean> remoteList = [
      password1,
      password2,
      password7,
      password4,
      password8,
      password9,
    ];

    var finalResult = List.from(localList);
    var addFunction = (PasswordBean bean) {
      finalResult.add(bean);
    };
    var deleteFunction = (PasswordBean bean) {
      finalResult.remove(bean);
    };

    var localFirstExecutor =
        MergeMethod.localFirst.createExecutor<PasswordBean>();
    var remoteFirstExecutor =
        MergeMethod.remoteFirst.createExecutor<PasswordBean>();
    var onlyRemoteExecutor =
        MergeMethod.onlyRemote.createExecutor<PasswordBean>();

    var localFirstResult = localFirstExecutor.merge(localList, remoteList);
    localFirstResult.apply(add: addFunction, delete: deleteFunction);
    assert(finalResult.contains(password1));
    assert(finalResult.contains(password2));
    assert(finalResult.contains(password3));
    assert(finalResult.contains(password4));
    assert(finalResult.contains(password5));
    assert(finalResult.contains(password6));
    assert(finalResult.contains(password7));
    assert(finalResult.contains(password9));
    assert(finalResult.length == 8);

    finalResult = List.from(localList);
    var remoteFirstResult = remoteFirstExecutor.merge(localList, remoteList);
    remoteFirstResult.apply(add: addFunction, delete: deleteFunction);
    assert(finalResult.contains(password1));
    assert(finalResult.contains(password2));
    assert(finalResult.contains(password8));
    assert(finalResult.contains(password4));
    assert(finalResult.contains(password5));
    assert(finalResult.contains(password6));
    assert(finalResult.contains(password7));
    assert(finalResult.contains(password9));
    assert(finalResult.length == 8);

    finalResult = List.from(localList);
    var onlyRemoteResult = onlyRemoteExecutor.merge(localList, remoteList);
    onlyRemoteResult.apply(add: addFunction, delete: deleteFunction);
    assert(finalResult.contains(password1));
    assert(finalResult.contains(password7));
    assert(finalResult.contains(password3));
    assert(finalResult.contains(password4));
    assert(finalResult.contains(password8));
    assert(finalResult.contains(password9));
    assert(finalResult.length == 6);
  });
}
