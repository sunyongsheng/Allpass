import 'package:allpass/core/param/constants.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:allpass/webdav/merge/merge_support.dart';

class MergeResult<T> {
  final T data;
  final int operation;

  MergeResult(this.data, this.operation);
}

extension MergeResultApply <T> on List<MergeResult<T>> {
  void apply({required void Function(T data) add, required void Function(T data) delete}) {
    this.forEach((element) {
      switch (element.operation) {
        case DataOperation.add:
          add(element.data);
          break;
        case DataOperation.delete:
          delete(element.data);
          break;
      }
    });
  }
}

abstract class MergeExecutor<T extends Object> {
  List<MergeResult<T>> merge(List<T> local, List<T> remote);
}

class LocalFirstMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    var pendingAdd = <MergeResult<T>>[];
    remote.forEach((remoteData) {
      if (!local.any((localData) => remoteData.mergeIdentify(localData))) {
        pendingAdd.add(MergeResult(remoteData, DataOperation.add));
      }
    });
    return pendingAdd;
  }
}

class RemoteFirstMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    var pendingAdd = remote.map((e) => MergeResult(e, DataOperation.add)).toList();
    var pendingDelete = <MergeResult<T>>[];
    local.forEach((localData) {
      if (remote.any((remoteData) => remoteData.mergeIdentify(localData))) {
        pendingDelete.add(MergeResult(localData, DataOperation.delete));
      }
    });
    return pendingAdd + pendingDelete;
  }
}

class OnlyRemoteMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    return remote.map((e) => MergeResult(e, DataOperation.add)).toList() +
        local.map((e) => MergeResult(e, DataOperation.delete)).toList();
  }
}

extension MergeExecutorCreator on MergeMethod {
  MergeExecutor<T> createExecutor<T extends Object>() {
    switch (this) {
      case MergeMethod.localFirst:
        return LocalFirstMergeExecutor();
      case MergeMethod.remoteFirst:
        return RemoteFirstMergeExecutor();
      case MergeMethod.onlyRemote:
        return OnlyRemoteMergeExecutor();
    }
  }
}
