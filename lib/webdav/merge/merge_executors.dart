import 'package:allpass/core/param/constants.dart';
import 'package:allpass/webdav/merge/merge_method.dart';
import 'package:allpass/webdav/merge/merge_support.dart';

enum DataSource {
  local,
  remote,
}

class MergeResult<T> {
  final T data;
  final int operation;
  final DataSource source;

  MergeResult(this.data, this.operation, this.source);
}

extension MergeResultApply <T> on List<MergeResult<T>> {
  void apply({
    required void Function(T data, DataSource source) onAdd,
    required void Function(T data, DataSource source) onDelete,
    void Function(T data, DataSource source)? onSkip,
  }) {
    this.forEach((element) {
      switch (element.operation) {
        case DataOperation.add:
          onAdd(element.data, element.source);
          break;
        case DataOperation.delete:
          onDelete(element.data, element.source);
          break;
        case DataOperation.skipped:
          onSkip?.call(element.data, element.source);
          break;
      }
    });
  }
}

abstract interface class MergeExecutor<T> {
  List<MergeResult<T>> merge(List<T> local, List<T> remote);
}

class LocalFirstMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    var pendingAdd = <MergeResult<T>>[];
    var remoteSkipped = <MergeResult<T>>[];
    remote.forEach((remoteData) {
      if (!local.any((localData) => remoteData.mergeIdentify(localData))) {
        pendingAdd.add(MergeResult(remoteData, DataOperation.add, DataSource.remote));
      } else {
        remoteSkipped.add(MergeResult(remoteData, DataOperation.skipped, DataSource.remote));
      }
    });
    return pendingAdd + remoteSkipped;
  }
}

class RemoteFirstMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    var pendingAdd = remote.map((e) => MergeResult(e, DataOperation.add, DataSource.remote)).toList();
    var pendingDelete = <MergeResult<T>>[];
    var localSkipped = <MergeResult<T>>[];
    local.forEach((localData) {
      if (remote.any((remoteData) => remoteData.mergeIdentify(localData))) {
        pendingDelete.add(MergeResult(localData, DataOperation.delete, DataSource.local));
      } else {
        localSkipped.add(MergeResult(localData, DataOperation.skipped, DataSource.local));
      }
    });
    return pendingAdd + pendingDelete + localSkipped;
  }
}

class OnlyRemoteMergeExecutor<T extends Object> implements MergeExecutor<T> {
  @override
  List<MergeResult<T>> merge(List<T> local, List<T> remote) {
    return remote.map((e) => MergeResult(e, DataOperation.add, DataSource.remote)).toList() +
        local.map((e) => MergeResult(e, DataOperation.delete, DataSource.local)).toList();
  }
}

extension MergeExecutorCreator on MergeMethod {
  MergeExecutor<T> createExecutor<T extends Object>() {
    return switch (this) {
      MergeMethod.localFirst => LocalFirstMergeExecutor(),
      MergeMethod.remoteFirst => RemoteFirstMergeExecutor(),
      MergeMethod.onlyRemote => OnlyRemoteMergeExecutor(),
    };
  }
}
