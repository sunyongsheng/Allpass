import 'package:flutter/foundation.dart';

class MultiItemEditProvider<T> extends ChangeNotifier {

  var _selectedItem = <T>[];
  var _editMode = false;

  List<T> get selectedItem => _selectedItem;
  bool get isEmpty => _selectedItem.isEmpty;
  int get selectedCount => _selectedItem.length;
  bool get editMode => _editMode;

  void switchEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }

  void select(bool select, T item) {
    if (select) {
      _selectedItem.add(item);
    } else {
      _selectedItem.remove(item);
    }
    notifyListeners();
  }

  void selectAll(List<T> itemList) {
    _selectedItem.clear();
    _selectedItem.addAll(itemList);
    notifyListeners();
  }

  void unselectAll() {
    _selectedItem.clear();
    notifyListeners();
  }

  bool isSelected(T item) {
    return _selectedItem.contains(item);
  }

}