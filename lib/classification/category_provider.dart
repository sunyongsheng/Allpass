import 'package:allpass/application.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/util/string_util.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {

  List<String> _folderList = [];
  List<String> _labelList = [];

  List<String> get folderList => _folderList;
  List<String> get labelList => _labelList;

  void init() {
    String folder = AllpassApplication.sp.getString(SPKeys.folder) ?? "";
    String label = AllpassApplication.sp.getString(SPKeys.label) ?? "";
    _folderList = StringUtil.waveLineSegStr2List(folder);
    _labelList = StringUtil.waveLineSegStr2List(label);
  }

  /// Label
  bool isLabelDuplicated(String label) {
    return _labelList.contains(label);
  }

  Future<bool> addLabel(List<String>? labels) async {
    if (labels == null) {
      return false;
    }
    int oldLen = _labelList.length;
    for (var label in labels) {
      if (label.isNotEmpty && !_labelList.contains(label)) {
        _labelList.add(label);
      }
    }
    if (_labelList.length > oldLen) {
      await _labelParamsPersistence();
      notifyListeners();
      return true;
    } else
      return false;
  }

  Future<void> updateLabel(int index, String newLabel) async {
    if (newLabel.isEmpty) {
      return;
    }

    _labelList[index] = newLabel;
    await _labelParamsPersistence();
    notifyListeners();
  }

  void reorderLabel(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = _labelList.removeAt(oldIndex);
    _labelList.insert(newIndex, item);
    _labelParamsPersistence();
    notifyListeners();
  }

  Future<void> deleteLabel(String label) async {
    if (_labelList.remove(label)) {
      await _labelParamsPersistence();
      notifyListeners();
    }
  }

  /// Folder
  bool isFolderDuplicated(String folder) {
    return _folderList.contains(folder);
  }

  Future<bool> addFolder(List<String> folders) async {
    int oldLen = _folderList.length;
    for (var folder in folders) {
      if (folder.isNotEmpty && !_folderList.contains(folder)) {
        _folderList.add(folder);
      }
    }
    if (_folderList.length > oldLen) {
      await _folderParamsPersistence();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateFolder(int index, String newFolder) async {
    if (newFolder.isEmpty) {
      return;
    }

    _folderList[index] = newFolder;
    await _folderParamsPersistence();
    notifyListeners();
  }

  void reorderFolder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    _folderParamsPersistence();
    notifyListeners();
  }

  Future<void> deleteFolder(String folder) async {
    if (_folderList.remove(folder)) {
      await _folderParamsPersistence();
      notifyListeners();
    }
  }

  Future<void> clear() async {
    _folderList.clear();
    _labelList.clear();
    await _folderParamsPersistence();
    await _labelParamsPersistence();
    notifyListeners();
  }

  Future<void> _labelParamsPersistence() async {
    await AllpassApplication.sp.setString(SPKeys.label, StringUtil.list2WaveLineSegStr(_labelList));
  }

  Future<void> _folderParamsPersistence() async {
    await AllpassApplication.sp.setString(SPKeys.folder, StringUtil.list2WaveLineSegStr(_folderList));
  }

}