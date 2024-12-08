import 'package:flutter/cupertino.dart';

class SelectedIndexProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int? get selectedIndex => _selectedIndex;

  Future<void> setSelectedIndex(int index) async {
    notifyListeners();
    try {
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    } catch (error) {
      throw Exception('Error: $error');
    } finally {
      notifyListeners();
    }
  }
}
